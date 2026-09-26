import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_reschedule_appointment.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_cubit.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

/// Bottom sheet para reagendar una cita.
/// Muestra un selector de fecha + hora inicio/fin y llama a [AppointmentCubit.rescheduleAppointment].
Future<void> showRescheduleSheet({
  required BuildContext context,
  required AppointmentModel appointment,
  required AppointmentCubit cubit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RescheduleSheet(appointment: appointment, cubit: cubit),
  );
}

class _RescheduleSheet extends StatefulWidget {
  const _RescheduleSheet({required this.appointment, required this.cubit});
  final AppointmentModel appointment;
  final AppointmentCubit cubit;

  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-cargar con la hora actual de la primera cita del appointment
    final services = widget.appointment.appointmentServices;
    final now = AppDateUtils.now().add(const Duration(hours: 1));

    if (services.isNotEmpty && services.first.startTime != null) {
      final start = services.first.startTime!;
      final end = services.first.endTime;
      _selectedDate = start.isAfter(now) ? start : now;
      _startTime = TimeOfDay(hour: start.hour, minute: start.minute);
      _endTime = end != null
          ? TimeOfDay(hour: end.hour, minute: end.minute)
          : TimeOfDay(
              hour: (start.hour + 1) % 24, minute: start.minute);
    } else {
      _selectedDate = now;
      _startTime = TimeOfDay(hour: now.hour, minute: 0);
      _endTime = TimeOfDay(hour: (now.hour + 1) % 24, minute: 0);
    }
  }

  /// Duración en minutos entre start y end para usarla al cambiar el inicio
  int get _durationMinutes {
    final startMin = _startTime.hour * 60 + _startTime.minute;
    final endMin = _endTime.hour * 60 + _endTime.minute;
    final diff = endMin - startMin;
    return diff > 0 ? diff : 40;
  }

  String _isoDateTime(DateTime date, TimeOfDay time) {
    final dt = tz.TZDateTime(AppDateUtils.defaultLocation,
        date.year, date.month, date.day, time.hour, time.minute);
    return AppDateUtils.toIso8601(dt);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: AppDateUtils.now(),
      lastDate: AppDateUtils.now().add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColorTheme),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = tz.TZDateTime(
          AppDateUtils.defaultLocation,
          picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColorTheme),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final endMin =
          picked.hour * 60 + picked.minute + _durationMinutes;
      setState(() {
        _startTime = picked;
        _endTime = TimeOfDay(hour: (endMin ~/ 60) % 24, minute: endMin % 60);
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColorTheme),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _submit() async {
    final startMin = _startTime.hour * 60 + _startTime.minute;
    final endMin = _endTime.hour * 60 + _endTime.minute;
    if (endMin <= startMin) {
      PonteSnackBar.show(
        context,
        message: 'La hora de fin debe ser posterior a la de inicio',
        type: TypeAlert.warning,
      );
      return;
    }

    setState(() => _submitting = true);

    final services = widget.appointment.appointmentServices;
    final int? workerId =
        services.isNotEmpty ? services.first.workerId : null;

    widget.cubit.rescheduleAppointment(
      RescheduleParams(
        appointmentId: widget.appointment.id,
        newStartTime: _isoDateTime(_selectedDate, _startTime),
        newEndTime: _isoDateTime(_selectedDate, _endTime),
        workerId: workerId,
      ),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE d \'de\' MMMM yyyy', 'es').format(_selectedDate);
    final startStr = _startTime.format(context);
    final endStr = _endTime.format(context);

    return Container(
      decoration: const BoxDecoration(
        color: backgroundColorTheme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: greyBlockColorTheme,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reagendar cita',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: blackColorTheme,
            ),
          ),
          const SizedBox(height: 20),

          // Selector de fecha
          _FieldTile(
            icon: Icons.calendar_today,
            label: 'Fecha',
            value: dateStr,
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),

          // Selector de hora inicio
          _FieldTile(
            icon: Icons.access_time,
            label: 'Hora inicio',
            value: startStr,
            onTap: _pickStartTime,
          ),
          const SizedBox(height: 12),

          // Selector de hora fin
          _FieldTile(
            icon: Icons.access_time_filled,
            label: 'Hora fin',
            value: endStr,
            onTap: _pickEndTime,
          ),
          const SizedBox(height: 20),

          // Warning message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cancelColorTheme.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cancelColorTheme.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: cancelColorTheme, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Importante: Solo puedes reagendar esta cita una vez. Una vez completado, no podrás volver a realizar esta operación.',
                    style: TextStyle(
                      color: cancelColorTheme,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColorTheme,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                          CircularProgressIndicator(color: whiteColorTheme, strokeWidth: 2),
                    )
                  : const Text(
                      'Confirmar reagendamiento',
                      style: TextStyle(color: whiteColorTheme, fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: whiteColorTheme,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColorTheme),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColorTheme, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: grayTextColorTheme,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blackColorTheme)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: grayTextColorTheme, size: 18),
          ],
        ),
      ),
    );
  }
}
