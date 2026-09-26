part of 'headquarter_cubit.dart';

sealed class HeadquarterState extends Equatable {
  const HeadquarterState();

  @override
  List<Object> get props => [];
}

final class HeadquarterInitial extends HeadquarterState {}

class HeadquarterIsLoading extends HeadquarterState {}

class HeadquarterError extends HeadquarterState {
  final String messageError;

  const HeadquarterError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

class InteractiveLoaded extends HeadquarterState {
  final String success;

  const InteractiveLoaded(this.success);

  @override
  List<Object> get props => [success];
}
