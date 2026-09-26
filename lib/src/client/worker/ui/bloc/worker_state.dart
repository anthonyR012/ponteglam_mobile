import 'package:equatable/equatable.dart';
import 'package:ponte_glam/shared/model/worker_model.dart';

sealed class WorkerState extends Equatable {
  const WorkerState();

  @override
  List<Object?> get props => [];
}

class WorkerInitial extends WorkerState {}

class WorkerLoading extends WorkerState {}

class WorkerLoaded extends WorkerState {
  final List<WorkerModel> workers;

  const WorkerLoaded(this.workers);

  @override
  List<Object?> get props => [workers];
}

class WorkerError extends WorkerState {
  final String message;

  const WorkerError(this.message);

  @override
  List<Object?> get props => [message];
}
