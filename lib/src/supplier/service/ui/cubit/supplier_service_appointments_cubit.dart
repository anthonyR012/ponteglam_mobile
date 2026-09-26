import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_list_supplier_appointments.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/device/storage/istorage.dart';

enum SupplierServiceAppointmentsStatus { initial, loading, success, failure }

class SupplierServiceAppointmentsState {
  final SupplierServiceAppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final String? errorMessage;
  final String activeStatus; // 'upcoming' or 'past'

  const SupplierServiceAppointmentsState({
    this.status = SupplierServiceAppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.activeStatus = 'upcoming',
  });

  SupplierServiceAppointmentsState copyWith({
    SupplierServiceAppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    String? errorMessage,
    String? activeStatus,
  }) {
    return SupplierServiceAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage ?? this.errorMessage,
      activeStatus: activeStatus ?? this.activeStatus,
    );
  }
}

class SupplierServiceAppointmentsCubit extends Cubit<SupplierServiceAppointmentsState> {
  final DoListSupplierAppointments doListSupplierAppointments;
  final IStorage storage;

  SupplierServiceAppointmentsCubit({
    required this.doListSupplierAppointments,
    required this.storage,
  }) : super(const SupplierServiceAppointmentsState());

  Future<void> loadAppointments({
    required int serviceId,
    String status = 'upcoming',
  }) async {
    emit(state.copyWith(
      status: SupplierServiceAppointmentsStatus.loading,
      activeStatus: status,
      errorMessage: null,
    ));

    final String? authToken = await storage.read(key: keyAuthToken);

    if (authToken == null) {
      emit(state.copyWith(
        status: SupplierServiceAppointmentsStatus.failure,
        errorMessage: "Token is missing",
      ));
      return;
    }

    final result = await doListSupplierAppointments(
      authToken: authToken,
      serviceId: serviceId,
      status: status,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SupplierServiceAppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (appointments) => emit(state.copyWith(
        status: SupplierServiceAppointmentsStatus.success,
        appointments: appointments,
      )),
    );
  }
}
