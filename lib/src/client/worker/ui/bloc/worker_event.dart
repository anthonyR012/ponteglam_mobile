import 'package:equatable/equatable.dart';

sealed class WorkerEvent extends Equatable {
  const WorkerEvent();

  @override
  List<Object?> get props => [];
}

class DoGetWorkersEvent extends WorkerEvent {
  final int? headQuarterId;
  final int? serviceId;

  const DoGetWorkersEvent({this.headQuarterId, this.serviceId});

  @override
  List<Object?> get props => [headQuarterId, serviceId];
}
