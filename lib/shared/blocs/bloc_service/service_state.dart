part of 'service_bloc.dart';

sealed class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

final class ServiceInitial extends ServiceState {}

class ServiceIsLoading extends ServiceState {}

class ServiceError extends ServiceState {
  final String message;
  const ServiceError(this.message);
  @override
  List<Object> get props => [message];
}

class MakeCallSuccess extends ServiceState {
  const MakeCallSuccess();
}

class MakeCallError extends ServiceState {
  final String message;
  const MakeCallError(this.message);
  @override
  List<Object> get props => [message];
}

class GetMinutesPrefixLoaded extends ServiceState {
  final String minutes;
  const GetMinutesPrefixLoaded(this.minutes);
  @override
  List<Object> get props => [minutes];
}

class GetFilterServiceLoaded extends ServiceState {
  final FilterServiceModel filter;
  const GetFilterServiceLoaded(this.filter);
  @override
  List<Object> get props => [filter];
}
