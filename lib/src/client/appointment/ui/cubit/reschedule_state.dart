import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';

enum RescheduleStatus { loading, loaded, failure }

enum RescheduleSubmitStatus { idle, submitting, success, failure }

class RescheduleState extends Equatable {
  const RescheduleState({
    this.status = RescheduleStatus.loading,
    this.submitStatus = RescheduleSubmitStatus.idle,
    this.dates = const [],
    this.selectedDate,
    this.selectedSlot,
    this.errorMessage,
  });

  final RescheduleStatus status;
  final RescheduleSubmitStatus submitStatus;
  final List<AvailableDateModel> dates;
  final AvailableDateModel? selectedDate;
  final AvailableSlotModel? selectedSlot;
  final String? errorMessage;

  RescheduleState copyWith({
    RescheduleStatus? status,
    RescheduleSubmitStatus? submitStatus,
    List<AvailableDateModel>? dates,
    AvailableDateModel? selectedDate,
    AvailableSlotModel? selectedSlot,
    bool clearSelectedSlot = false,
    String? errorMessage,
  }) =>
      RescheduleState(
        status: status ?? this.status,
        submitStatus: submitStatus ?? this.submitStatus,
        dates: dates ?? this.dates,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedSlot:
            clearSelectedSlot ? null : selectedSlot ?? this.selectedSlot,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, submitStatus, dates, selectedDate, selectedSlot, errorMessage];
}
