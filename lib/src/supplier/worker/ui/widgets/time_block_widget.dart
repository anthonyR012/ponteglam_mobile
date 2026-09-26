import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';

class TimeBlockWidget extends StatefulWidget {
  const TimeBlockWidget({super.key});

  @override
  State<TimeBlockWidget> createState() => _TimeBlockWidgetState();
}

class _TimeBlockWidgetState extends State<TimeBlockWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bloqueo de Agenda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bloquea un horario específico o días completos para este trabajador.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildDateSelectors(),
            const SizedBox(height: 16),
            ModernTextField(
              controller: _reasonController,
              label: 'Motivo (opcional)',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColorTheme,
                  disabledBackgroundColor:
                      primaryColorTheme.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (_startDate != null &&
                        _endDate != null &&
                        _startTime != null &&
                        _endTime != null)
                    ? _submitBlock
                    : null,
                child: const Text('Bloquear Horario',
                    style: TextStyle(
                        color: whiteColorTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DateTile(
                label: 'Inicio',
                date: _startDate,
                time: _startTime,
                onTap: () => _selectDateTime(isStart: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DateTile(
                label: 'Fin',
                date: _endDate,
                time: _endTime,
                onTap: () => _selectDateTime(isStart: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      setState(() {
        if (isStart) {
          _startDate = date;
          _startTime = time ?? const TimeOfDay(hour: 0, minute: 0);
        } else {
          _endDate = date;
          _endTime = time ?? const TimeOfDay(hour: 23, minute: 59);
        }
      });
    }
  }

  void _submitBlock() {
    if (_startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _endTime == null) {
      PonteSnackBar.show(
        context,
        message: 'Por favor selecciona las fechas y horas',
        type: TypeAlert.warning,
      );
      return;
    }

    final start = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final end = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (end.isBefore(start)) {
      PonteSnackBar.show(
        context,
        message: 'La fecha de fin debe ser posterior a la de inicio',
        type: TypeAlert.warning,
      );
      return;
    }

    context
        .read<WorkerManagementCubit>()
        .addBlock(start, end, _reasonController.text);

    // Clear form
    setState(() {
      _startDate = null;
      _endDate = null;
      _startTime = null;
      _endTime = null;
      _reasonController.clear();
    });
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _DateTile(
      {required this.label, this.date, this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              date == null
                  ? 'Seleccionar'
                  : '${date!.day}/${date!.month}/${date!.year}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            if (time != null)
              Text(time!.format(context), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
