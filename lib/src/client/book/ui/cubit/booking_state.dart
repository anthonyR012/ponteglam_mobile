import 'package:equatable/equatable.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
  @override
  List<Object?> get props => [];
}

class BookingLoadingDates extends BookingState {
  const BookingLoadingDates();
  @override
  List<Object?> get props => [];
}

class BookingDatesLoaded extends BookingState {
  const BookingDatesLoaded({
    required this.availableDates,
    required this.selectedDate,
    this.selectedSlot,
    this.isHomeService = false,
  });

  final List<AvailableDateModel> availableDates;
  final AvailableDateModel selectedDate;
  final AvailableSlotModel? selectedSlot;
  final bool isHomeService;

  @override
  List<Object?> get props => [availableDates, selectedDate, selectedSlot, isHomeService];
}

class BookingDateChanged extends BookingState {
  const BookingDateChanged({
    required this.availableDates,
    required this.selectedDate,
    this.selectedSlot,
    this.isHomeService = false,
  });

  final List<AvailableDateModel> availableDates;
  final AvailableDateModel selectedDate;
  final AvailableSlotModel? selectedSlot;
  final bool isHomeService;

  @override
  List<Object?> get props => [availableDates, selectedDate, selectedSlot, isHomeService];
}

class BookingSlotSelected extends BookingState {
  const BookingSlotSelected({
    required this.availableDates,
    required this.selectedDate,
    required this.selectedSlot,
    this.isHomeService = false,
    this.selectedHomeAddress,
    this.availableAddons = const [],
    this.selectedAddons = const [],
    this.isLoadingAddons = false,
  });

  final List<AvailableDateModel> availableDates;
  final AvailableDateModel selectedDate;
  final AvailableSlotModel selectedSlot;
  final bool isHomeService;
  final AddressModel? selectedHomeAddress;
  final List<AddonModel> availableAddons;
  final List<AddonModel> selectedAddons;
  final bool isLoadingAddons;

  @override
  List<Object?> get props => [
        availableDates,
        selectedDate,
        selectedSlot,
        isHomeService,
        selectedHomeAddress,
        availableAddons,
        selectedAddons,
        isLoadingAddons,
      ];
}

class BookingNoAvailability extends BookingState {
  const BookingNoAvailability();
  @override
  List<Object?> get props => [];
}

class BookingConfirmed extends BookingState {
  const BookingConfirmed({
    required this.appointmentId,
  });

  final int appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class BookingError extends BookingState {
  const BookingError(this.failure);
  final Failure failure;
  @override
  List<Object?> get props => [failure];
}
