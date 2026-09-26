import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/worker_block_model.dart';
import 'package:ponte_glam/src/supplier/worker/domain/repository/worker_repository.dart';
import 'worker_management_state.dart';

class WorkerManagementCubit extends Cubit<WorkerManagementState> {
  final WorkerRepository _repository;
  final int headquarterId;

  WorkerManagementCubit(
    this._repository, 
    this.headquarterId, 
    List<ServiceModel> availableServices,
  ) : super(WorkerManagementState(availableServices: availableServices));

  Future<void> loadStaff() async {
    emit(state.copyWith(status: WorkerManagementStatus.loading));
    try {
      final staff = await _repository.getStaff(headquarterId);
      emit(state.copyWith(status: WorkerManagementStatus.success, staff: staff));
    } catch (e) {
      emit(state.copyWith(status: WorkerManagementStatus.failure, errorMessage: e.toString()));
    }
  }

  void selectWorker(int workerId) {
    final selected = state.staff.firstWhere((w) => w.workerId == workerId);
    emit(state.copyWith(selectedWorker: selected));
  }

  Future<void> onboardWorker({required bool isAnonymous, String? name, String? email, String? phone}) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.onboardWorker(
        headquarterId: headquarterId,
        isAnonymous: isAnonymous,
        name: name,
        email: email,
        phone: phone,
      );
      await loadStaff();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isActionLoading: false));
    }
  }

  Future<void> linkService(int serviceId) async {
    if (state.selectedWorker == null) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.linkService(state.selectedWorker!.workerId, serviceId);
      await loadStaff();
      // Update selected worker reference
      selectWorker(state.selectedWorker!.workerId);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isActionLoading: false));
    }
  }

  Future<void> unlinkService(int serviceId) async {
    if (state.selectedWorker == null) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final message = await _repository.unlinkService(state.selectedWorker!.workerId, serviceId);
      await loadStaff();
      selectWorker(state.selectedWorker!.workerId);
      if (message != null) {
        emit(state.copyWith(successMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isActionLoading: false));
    }
  }

  Future<void> addBlock(DateTime start, DateTime end, String? reason) async {
    if (state.selectedWorker == null) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final block = WorkerBlockModel(
        workerId: state.selectedWorker!.workerId,
        startTime: start,
        endTime: end,
        reason: reason,
      );
      await _repository.addBlock(state.selectedWorker!.workerId, block);
      emit(state.copyWith(successMessage: 'Horario bloqueado exitosamente.'));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isActionLoading: false));
    }
  }

  Future<void> removeWorkerFromHq(int workerId) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.removeFromHq(workerId, headquarterId);
      if (state.selectedWorker?.workerId == workerId) {
        emit(state.copyWith(selectedWorker: null));
      }
      await loadStaff();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isActionLoading: false));
    }
  }
}
