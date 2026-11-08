import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/shared/widgets/day_calendar_widget.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/reschedule_cubit.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/reschedule_state.dart';

/// Abre el selector de nuevo horario. Devuelve `true` si la cita se reagendó.
Future<bool> showRescheduleSheet({
  required BuildContext context,
  required AppointmentModel appointment,
}) async {
  final bool? rescheduled = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => getIt<RescheduleCubit>()..loadSlots(appointment.id),
      child: _RescheduleSheet(appointment: appointment),
    ),
  );
  return rescheduled ?? false;
}

DateTime _local(String iso) => AppDateUtils.fromUtc(DateTime.parse(iso));

String _hour(DateTime dt) => DateFormat('hh:mm a', 'es').format(dt);

class _RescheduleSheet extends StatelessWidget {
  const _RescheduleSheet({required this.appointment});
  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = appointment.appointmentServices.firstOrNull;
    final media = MediaQuery.of(context);

    return BlocListener<RescheduleCubit, RescheduleState>(
      listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == RescheduleSubmitStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.submitStatus == RescheduleSubmitStatus.failure) {
          PonteSnackBar.show(
            context,
            message: state.errorMessage ?? '',
            type: TypeAlert.error,
          );
        }
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.88),
        decoration: const BoxDecoration(
          color: backgroundColorTheme,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          top: 12,
          bottom: media.viewInsets.bottom + media.padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Handle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: _Header(current: current),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _Body(appointmentId: appointment.id),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _InfoBanner(text: l10n.rescheduleOnceWarning),
                  const SizedBox(height: 12),
                  _ConfirmButton(appointmentId: appointment.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: greyBlockColorTheme,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.current});
  final AppointmentServiceModel? current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final DateTime? start = current?.startTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.titleReschedule,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColorTheme,
          ),
        ),
        if (current?.workerName != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: secondaryColorTheme),
              const SizedBox(width: 6),
              Text(
                l10n.rescheduleWithWorker(current!.workerName!),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: secondaryColorTheme,
                ),
              ),
            ],
          ),
        ],
        if (start != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.rescheduleCurrentAppointment(
              '${DateFormat("EEE d 'de' MMM", 'es').format(start)} · ${_hour(start)}',
            ),
            style: const TextStyle(fontSize: 12, color: grayTextColorTheme),
          ),
        ],
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.appointmentId});
  final int appointmentId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<RescheduleCubit, RescheduleState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.dates != curr.dates ||
          prev.selectedDate != curr.selectedDate ||
          prev.selectedSlot != curr.selectedSlot,
      builder: (context, state) => switch (state.status) {
        RescheduleStatus.loading => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: CircularProgressIndicator(color: primaryColorTheme),
            ),
          ),
        RescheduleStatus.failure => _Message(
            text: state.errorMessage ?? '',
            actionLabel: l10n.titleRetry,
            onAction: () =>
                context.read<RescheduleCubit>().loadSlots(appointmentId),
          ),
        RescheduleStatus.loaded when state.dates.isEmpty =>
          _Message(text: l10n.rescheduleNoAvailability),
        RescheduleStatus.loaded => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(l10n.rescheduleChooseDay),
              _DayPicker(dates: state.dates, selected: state.selectedDate),
              const SizedBox(height: 16),
              _SectionTitle(l10n.rescheduleChooseTime),
              _SlotGrid(
                slots: state.selectedDate?.slots ?? const [],
                selected: state.selectedSlot,
              ),
              if (state.selectedSlot != null) ...[
                const SizedBox(height: 16),
                _NewAppointmentSummary(slot: state.selectedSlot!),
              ],
            ],
          ),
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: blackColorTheme,
          ),
        ),
      );
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.dates, required this.selected});
  final List<AvailableDateModel> dates;
  final AvailableDateModel? selected;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        children: dates.map((date) {
          final DateTime day = DateTime.parse(date.date);
          return DayCalendarCard(
            width: width,
            numberDay: day.day.toString(),
            day: DateFormat('EEE', 'es').format(day),
            isSelected: date.date == selected?.date,
            isLoading: false,
            onTap: () => context.read<RescheduleCubit>().selectDate(date),
          );
        }).toList(),
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.slots, required this.selected});
  final List<AvailableSlotModel> slots;
  final AvailableSlotModel? selected;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return _Message(text: AppLocalizations.of(context).rescheduleNoSlotsDay);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: slots.map((slot) {
          final bool isSelected = slot == selected;
          return ChoiceChip(
            label: Text(_hour(_local(slot.startTime))),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => context.read<RescheduleCubit>().selectSlot(slot),
            selectedColor: primaryColorTheme,
            backgroundColor: whiteColorTheme,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? whiteColorTheme : primaryColorTheme,
            ),
            side: const BorderSide(color: primaryColorTheme),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NewAppointmentSummary extends StatelessWidget {
  const _NewAppointmentSummary({required this.slot});
  final AvailableSlotModel slot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final DateTime start = _local(slot.startTime);
    final DateTime end = _local(slot.endTime);
    final String day = DateFormat("EEEE d 'de' MMMM", 'es').format(start);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: secondaryColorTheme.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColorTheme.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rescheduleNewAppointment,
            style: const TextStyle(fontSize: 11, color: grayTextColorTheme),
          ),
          const SizedBox(height: 4),
          Text(
            '${day[0].toUpperCase()}${day.substring(1)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: blackColorTheme,
            ),
          ),
          Text(
            '${_hour(start)} – ${_hour(end)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: secondaryColorTheme,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.rescheduleDurationHint(end.difference(start).inMinutes),
            style: const TextStyle(fontSize: 11, color: grayTextColorTheme),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onAction});
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: grayTextColorTheme),
            ),
            if (actionLabel != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ),
      );
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cancelColorTheme.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cancelColorTheme.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: cancelColorTheme, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: cancelColorTheme,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.appointmentId});
  final int appointmentId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<RescheduleCubit, RescheduleState>(
      buildWhen: (prev, curr) =>
          prev.selectedSlot != curr.selectedSlot ||
          prev.submitStatus != curr.submitStatus,
      builder: (context, state) {
        final bool submitting =
            state.submitStatus == RescheduleSubmitStatus.submitting;
        final bool enabled = state.selectedSlot != null && !submitting;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: enabled
                ? () => context.read<RescheduleCubit>().submit(appointmentId)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColorTheme,
              disabledBackgroundColor:
                  grayTextColorTheme.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: whiteColorTheme, strokeWidth: 2),
                  )
                : Text(
                    l10n.titleRescheduleConfirm,
                    style: TextStyle(
                      color: enabled ? whiteColorTheme : grayTextColorTheme,
                      fontSize: 15,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
