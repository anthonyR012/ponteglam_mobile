import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_cancel_appointment.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_get_appointment_detail.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_list_appointments.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_reschedule_appointment.dart';
import 'package:ponte_glam/src/client/appointment/domain/use_case/do_rate_service.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit({
    required this.doListAppointments,
    required this.doGetAppointmentDetail,
    required this.doCancelAppointment,
    required this.doRescheduleAppointment,
    required this.doRateService,
  }) : super(const AppointmentState());

  final DoListAppointments doListAppointments;
  final DoGetAppointmentDetail doGetAppointmentDetail;
  final DoCancelAppointment doCancelAppointment;
  final DoRescheduleAppointment doRescheduleAppointment;
  final DoRateService doRateService;

  Future<void> loadAppointments({String? filter}) async {
    emit(state.copyWith(
      status: AppointmentStatus.loading,
      activeFilter: filter,
      errorMessage: null,
    ));
    final result = await doListAppointments(filter: filter);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentStatus.failure,
        errorMessage: failure.message,
      )),
      (appointments) => emit(state.copyWith(
        status: AppointmentStatus.success,
        appointments: appointments,
      )),
    );
  }

  Future<void> loadAppointmentDetail(int appointmentId) async {
    emit(state.copyWith(
      status: AppointmentStatus.loading,
      errorMessage: null,
    ));
    final result = await doGetAppointmentDetail(appointmentId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentStatus.failure,
        errorMessage: failure.message,
      )),
      (appointment) => emit(state.copyWith(
        status: AppointmentStatus.success,
        selectedAppointment: appointment,
      )),
    );
  }

  Future<void> cancelAppointment(int appointmentId, {String? reason}) async {
    emit(state.copyWith(
      actionStatus: AppointmentActionStatus.loading,
      actionErrorMessage: null,
    ));
    final result =
        await doCancelAppointment(appointmentId: appointmentId, reason: reason);
    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.success,
      )),
    );
  }

  Future<void> rescheduleAppointment(RescheduleParams params) async {
    emit(state.copyWith(
      actionStatus: AppointmentActionStatus.loading,
      actionErrorMessage: null,
    ));
    final result = await doRescheduleAppointment(params);
    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.success,
      )),
    );
  }

  Future<void> rateAppointment(RateServiceParams params) async {
    emit(state.copyWith(
      actionStatus: AppointmentActionStatus.loading,
      actionErrorMessage: null,
    ));
    final result = await doRateService(params);
    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionStatus: AppointmentActionStatus.success,
      )),
    );
  }

  void resetActionStatus() {
    emit(state.copyWith(actionStatus: AppointmentActionStatus.idle));
  }
}
