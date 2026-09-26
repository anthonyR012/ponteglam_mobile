import 'package:equatable/equatable.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';

enum AppointmentStatus { initial, loading, success, failure }

enum AppointmentActionStatus { idle, loading, success, failure }

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final AppointmentActionStatus actionStatus;
  final List<AppointmentModel> appointments;
  final AppointmentModel? selectedAppointment;
  final String? errorMessage;
  final String? actionErrorMessage;
  final String? activeFilter;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.actionStatus = AppointmentActionStatus.idle,
    this.appointments = const [],
    this.selectedAppointment,
    this.errorMessage,
    this.actionErrorMessage,
    this.activeFilter,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    AppointmentActionStatus? actionStatus,
    List<AppointmentModel>? appointments,
    AppointmentModel? selectedAppointment,
    String? errorMessage,
    String? actionErrorMessage,
    String? activeFilter,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      appointments: appointments ?? this.appointments,
      selectedAppointment: selectedAppointment ?? this.selectedAppointment,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        appointments,
        selectedAppointment,
        errorMessage,
        actionErrorMessage,
        activeFilter,
      ];
}
