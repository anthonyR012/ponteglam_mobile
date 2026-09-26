import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/src/client/book/domain/repository/booking_repository.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_state.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._repository) : super(const BookingInitial());

  final BookingRepository _repository;

  int? _serviceId;
  int? _workerId;
  int? _headQuarterId;

  Future<void> loadDates({
    required int serviceId,
    int? workerId,
    int? headQuarterId,
    int days = 15,
  }) async {
    _serviceId = serviceId;
    _workerId = workerId;
    _headQuarterId = headQuarterId;

    emit(const BookingLoadingDates());

    final IStorage storage = getIt<IStorage>();
    final authToken = await storage.read(key: keyAuthToken) ?? '';

    final result = await _repository.getAvailableDates(
      authToken: authToken,
      serviceId: serviceId,
      workerId: workerId,
      headQuarterId: headQuarterId,
      days: days,
    );

    result.fold(
      (failure) => emit(BookingError(failure)),
      (dates) {
        if (dates.isEmpty) {
          emit(const BookingNoAvailability());
        } else {
          emit(BookingDatesLoaded(
            availableDates: dates,
            selectedDate: dates.first,
          ));
        }
      },
    );
  }

  void selectDate(AvailableDateModel date) {
    final dates = _currentDates;
    if (dates == null) return;
    emit(BookingDateChanged(
      availableDates: dates,
      selectedDate: date,
      selectedSlot: null,
      isHomeService: false,
    ));
  }

  void selectSlot(AvailableSlotModel slot) async {
    final dates = _currentDates;
    final selectedDate = _currentSelectedDate;
    if (dates == null || selectedDate == null) return;
    emit(BookingSlotSelected(
      availableDates: dates,
      selectedDate: selectedDate,
      selectedSlot: slot,
      isHomeService: false,
      selectedHomeAddress: null,
      availableAddons: const [],
      selectedAddons: const [],
      isLoadingAddons: _serviceId != null,
    ));

    if (_serviceId != null) {
      final addonRepository = getIt<AddonRepository>();
      final result = await addonRepository.getServiceAddons(_serviceId!);
      result.fold(
        (failure) {
          // ignore: avoid_print
          print('[BookingCubit] Error cargando addons: ${failure.message}');
          final s = state;
          if (s is BookingSlotSelected && s.selectedSlot == slot) {
            emit(BookingSlotSelected(
              availableDates: s.availableDates,
              selectedDate: s.selectedDate,
              selectedSlot: s.selectedSlot,
              isHomeService: s.isHomeService,
              selectedHomeAddress: s.selectedHomeAddress,
              availableAddons: const [],
              selectedAddons: s.selectedAddons,
              isLoadingAddons: false,
            ));
          }
        },
        (data) {
          final s = state;
          if (s is BookingSlotSelected && s.selectedSlot == slot) {
            final available = data['linked'] ?? [];
            // ignore: avoid_print
            print('[BookingCubit] Addons cargados: ${available.length}');
            emit(BookingSlotSelected(
              availableDates: s.availableDates,
              selectedDate: s.selectedDate,
              selectedSlot: s.selectedSlot,
              isHomeService: s.isHomeService,
              selectedHomeAddress: s.selectedHomeAddress,
              availableAddons: available,
              selectedAddons: const [],
              isLoadingAddons: false,
            ));
          }
        },
      );
    }
  }

  void toggleHomeService(bool value) {
    final s = state;
    if (s is! BookingSlotSelected) return;
    emit(BookingSlotSelected(
      availableDates: s.availableDates,
      selectedDate: s.selectedDate,
      selectedSlot: s.selectedSlot,
      isHomeService: value,
      selectedHomeAddress: s.selectedHomeAddress,
      availableAddons: s.availableAddons,
      selectedAddons: s.selectedAddons,
      isLoadingAddons: s.isLoadingAddons,
    ));
  }

  void selectHomeAddress(AddressModel address) {
    final s = state;
    if (s is! BookingSlotSelected) return;
    emit(BookingSlotSelected(
      availableDates: s.availableDates,
      selectedDate: s.selectedDate,
      selectedSlot: s.selectedSlot,
      isHomeService: s.isHomeService,
      selectedHomeAddress: address,
      availableAddons: s.availableAddons,
      selectedAddons: s.selectedAddons,
      isLoadingAddons: s.isLoadingAddons,
    ));
  }

  void toggleAddon(AddonModel addon) {
    final s = state;
    if (s is! BookingSlotSelected) return;

    final currentSelected = List<AddonModel>.from(s.selectedAddons);
    if (currentSelected.any((a) => a.id == addon.id)) {
      currentSelected.removeWhere((a) => a.id == addon.id);
    } else {
      currentSelected.add(addon);
    }

    emit(BookingSlotSelected(
      availableDates: s.availableDates,
      selectedDate: s.selectedDate,
      selectedSlot: s.selectedSlot,
      isHomeService: s.isHomeService,
      selectedHomeAddress: s.selectedHomeAddress,
      availableAddons: s.availableAddons,
      selectedAddons: currentSelected,
      isLoadingAddons: s.isLoadingAddons,
    ));
  }

  Future<void> createBooking({
    required int serviceId,
    required int workerId,
    required String startTime,
    required String endTime,
    String paymentMethod = 'card',
    bool isHomeService = false,
    int? homeAddressId,
    List<AddonModel> selectedAddons = const [],
  }) async {
    final IStorage storage = getIt<IStorage>();
    final authToken = await storage.read(key: keyAuthToken) ?? '';

    final totalAddonMinutes =
        selectedAddons.fold<int>(0, (sum, a) => sum + a.durationMinutes);
    final originalEndTime = DateTime.parse(endTime);
    final adjustedEndTime =
        originalEndTime.add(Duration(minutes: totalAddonMinutes));
    final adjustedEndTimeStr = adjustedEndTime.toIso8601String();

    final addonIds = selectedAddons.map((a) => a.id).toList();

    final result = await _repository.createAppointment(
      authToken: authToken,
      serviceId: serviceId,
      workerId: workerId,
      startTime: startTime,
      endTime: adjustedEndTimeStr,
      paymentMethod: paymentMethod,
      isHomeService: isHomeService,
      homeAddressId: homeAddressId,
      addonIds: addonIds,
    );

    result.fold(
      (failure) => emit(BookingError(failure)),
      (response) => emit(BookingConfirmed(
        appointmentId: response.appointmentId,
      )),
    );
  }

  void reset() {
    _serviceId = null;
    _workerId = null;
    _headQuarterId = null;
    emit(const BookingInitial());
  }

  Future<void> refreshAfterBooking() async {
    if (_serviceId != null && _workerId != null) {
      await loadDates(
        serviceId: _serviceId!,
        workerId: _workerId,
        headQuarterId: _headQuarterId,
      );
    } else {
      reset();
    }
  }

  List<AvailableDateModel>? get _currentDates {
    final s = state;
    if (s is BookingDatesLoaded) return s.availableDates;
    if (s is BookingDateChanged) return s.availableDates;
    if (s is BookingSlotSelected) return s.availableDates;
    return null;
  }

  AvailableDateModel? get _currentSelectedDate {
    final s = state;
    if (s is BookingDatesLoaded) return s.selectedDate;
    if (s is BookingDateChanged) return s.selectedDate;
    if (s is BookingSlotSelected) return s.selectedDate;
    return null;
  }
}
