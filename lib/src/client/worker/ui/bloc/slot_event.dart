import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/src/client/book/domain/use_case/do_create_appointment.dart';

sealed class SlotEvent extends Equatable {
  const SlotEvent();

  @override
  List<Object?> get props => [];
}

class DoGetAvailableSlotsEvent extends SlotEvent {
  const DoGetAvailableSlotsEvent({
    required this.date,
    required this.serviceId,
    this.workerId,
    this.headQuarterId,
    this.days,
  });

  final String date;
  final int serviceId;
  final int? workerId;
  final int? headQuarterId;
  final int? days;

  @override
  List<Object?> get props => [date, serviceId, workerId, headQuarterId, days];
}

class SelectWorkerSlotEvent extends SlotEvent {
  const SelectWorkerSlotEvent(this.workerId);
  final int? workerId;

  @override
  List<Object?> get props => [workerId];
}

class SelectDateSlotEvent extends SlotEvent {
  const SelectDateSlotEvent(this.date);
  final String date;

  @override
  List<Object?> get props => [date];
}

class SelectTimeSlotEvent extends SlotEvent {
  const SelectTimeSlotEvent(this.slot);
  final AvailableSlotModel? slot;

  @override
  List<Object?> get props => [slot];
}

class CreateAppointmentEvent extends SlotEvent {
  final CreateAppointmentParams params;
  const CreateAppointmentEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class ResetPaymentStatusEvent extends SlotEvent {}
