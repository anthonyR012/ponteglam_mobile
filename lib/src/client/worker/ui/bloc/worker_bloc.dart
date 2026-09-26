import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/client/worker/domain/use_case/do_get_workers.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/worker_event.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/worker_state.dart';

class WorkerBloc extends Bloc<WorkerEvent, WorkerState> {
  final DoGetWorkers _doGetWorkers;

  WorkerBloc(this._doGetWorkers) : super(WorkerInitial()) {
    on<DoGetWorkersEvent>(_onDoGetWorkers);
  }

  Future<void> _onDoGetWorkers(
      DoGetWorkersEvent event, Emitter<WorkerState> emit) async {
    emit(WorkerLoading());
    final result = await _doGetWorkers.call(
        headQuarterId: event.headQuarterId, serviceId: event.serviceId);
    
    result.fold(
      (failure) => emit(WorkerError(failure.message)),
      (workers) => emit(WorkerLoaded(workers)),
    );
  }
}
