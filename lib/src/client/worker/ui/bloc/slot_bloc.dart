import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/client/book/domain/use_case/do_create_appointment.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/slot_event.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/slot_state.dart';

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final DoCreateAppointment doCreateAppointment;

  SlotBloc(this.doCreateAppointment) : super(const SlotState()) {
    on<SelectWorkerSlotEvent>(_onSelectWorker);
    on<SelectDateSlotEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<ResetPaymentStatusEvent>(_onResetPaymentStatus);
  }

  void _onSelectWorker(SelectWorkerSlotEvent event, Emitter<SlotState> emit) {
    emit(state.copyWith(selectedWorkerId: () => event.workerId));
  }

  void _onSelectDate(SelectDateSlotEvent event, Emitter<SlotState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectTimeSlot(SelectTimeSlotEvent event, Emitter<SlotState> emit) {
    emit(state.copyWith(selectedSlot: () => event.slot));
  }

  Future<void> _onCreateAppointment(
      CreateAppointmentEvent event, Emitter<SlotState> emit) async {
    emit(state.copyWith(bookingStatus: BookingStatus.loading));

    final result = await doCreateAppointment.call(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
          bookingStatus: BookingStatus.error, messageError: failure.message)),
      (response) => emit(state.copyWith(
        bookingStatus: BookingStatus.cashSuccess,
        appointmentId: response.appointmentId,
      )),
    );
  }

  void _onResetPaymentStatus(
      ResetPaymentStatusEvent event, Emitter<SlotState> emit) {
    emit(state.copyWith(bookingStatus: BookingStatus.initial));
  }
}
