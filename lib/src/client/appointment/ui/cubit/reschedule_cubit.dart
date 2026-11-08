import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_list_reschedule_slots.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_reschedule_appointment.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/reschedule_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  RescheduleCubit({
    required this.doListRescheduleSlots,
    required this.doRescheduleAppointment,
  }) : super(const RescheduleState());

  final DoListRescheduleSlots doListRescheduleSlots;
  final DoRescheduleAppointment doRescheduleAppointment;

  Future<void> loadSlots(int appointmentId) async {
    emit(state.copyWith(status: RescheduleStatus.loading));
    final result = await doListRescheduleSlots(appointmentId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: RescheduleStatus.failure,
        errorMessage: failure.message,
      )),
      (dates) {
        final AvailableDateModel? keepDate = dates
            .where((d) => d.date == state.selectedDate?.date)
            .firstOrNull;
        emit(RescheduleState(
          status: RescheduleStatus.loaded,
          dates: dates,
          selectedDate: keepDate ?? dates.firstOrNull,
        ));
      },
    );
  }

  void selectDate(AvailableDateModel date) => emit(state.copyWith(
        selectedDate: date,
        clearSelectedSlot: true,
      ));

  void selectSlot(AvailableSlotModel slot) =>
      emit(state.copyWith(selectedSlot: slot));

  Future<void> submit(int appointmentId) async {
    final AvailableSlotModel? slot = state.selectedSlot;
    if (slot == null ||
        state.submitStatus == RescheduleSubmitStatus.submitting) {
      return;
    }

    emit(state.copyWith(submitStatus: RescheduleSubmitStatus.submitting));
    final result = await doRescheduleAppointment(RescheduleParams(
      appointmentId: appointmentId,
      newStartTime: slot.startTime,
    ));
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(state.copyWith(
          submitStatus: RescheduleSubmitStatus.failure,
          errorMessage: failure.message,
          clearSelectedSlot: true,
        ));
        // El slot pudo ocuparse mientras el usuario elegía: se refresca la agenda.
        await loadSlots(appointmentId);
      },
      (_) async =>
          emit(state.copyWith(submitStatus: RescheduleSubmitStatus.success)),
    );
  }
}
