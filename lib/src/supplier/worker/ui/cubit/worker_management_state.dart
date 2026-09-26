import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';

enum WorkerManagementStatus { initial, loading, success, failure }

class WorkerManagementState extends Equatable {
  final WorkerManagementStatus status;
  final List<StaffMemberModel> staff;
  final List<ServiceModel> availableServices;
  final StaffMemberModel? selectedWorker;
  final String? errorMessage;
  final String? successMessage;
  final bool isActionLoading;

  const WorkerManagementState({
    this.status = WorkerManagementStatus.initial,
    this.staff = const [],
    this.availableServices = const [],
    this.selectedWorker,
    this.errorMessage,
    this.successMessage,
    this.isActionLoading = false,
  });

  WorkerManagementState copyWith({
    WorkerManagementStatus? status,
    List<StaffMemberModel>? staff,
    List<ServiceModel>? availableServices,
    StaffMemberModel? selectedWorker,
    String? errorMessage,
    String? successMessage,
    bool? isActionLoading,
  }) {
    return WorkerManagementState(
      status: status ?? this.status,
      staff: staff ?? this.staff,
      availableServices: availableServices ?? this.availableServices,
      selectedWorker: selectedWorker ?? this.selectedWorker,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [status, staff, availableServices, selectedWorker, errorMessage, successMessage, isActionLoading];
}
