import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';

class SlotState extends Equatable {
  const SlotState({
    this.status = SlotStatus.initial,
    this.bookingStatus = BookingStatus.initial,
    this.slots = const [],
    this.messageError = '',
    this.selectedWorkerId,
    this.selectedDate,
    this.selectedSlot,
    this.appointmentId,
  });

  final SlotStatus status;
  final BookingStatus bookingStatus;
  final List<AvailableSlotModel> slots;
  final String messageError;
  final int? selectedWorkerId;
  final String? selectedDate;
  final AvailableSlotModel? selectedSlot;
  final int? appointmentId;

  SlotState copyWith({
    SlotStatus? status,
    BookingStatus? bookingStatus,
    List<AvailableSlotModel>? slots,
    String? messageError,
    int? Function()? selectedWorkerId,
    String? selectedDate,
    AvailableSlotModel? Function()? selectedSlot,
    int? appointmentId,
  }) {
    return SlotState(
      status: status ?? this.status,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      slots: slots ?? this.slots,
      messageError: messageError ?? this.messageError,
      selectedWorkerId:
          selectedWorkerId != null ? selectedWorkerId() : this.selectedWorkerId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot != null ? selectedSlot() : this.selectedSlot,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookingStatus,
        slots,
        messageError,
        selectedWorkerId,
        selectedDate,
        selectedSlot,
        appointmentId,
      ];
}

enum SlotStatus { initial, loading, loaded, error }

enum BookingStatus { initial, loading, success, cashSuccess, error }
