part of 'confirmation_cubit.dart';

sealed class ConfirmationState extends Equatable {
  const ConfirmationState();

  @override
  List<Object> get props => [];
}

final class ConfirmationInitial extends ConfirmationState {}

class ConfirmationIsLoading extends ConfirmationState {}

class ConfirmationError extends ConfirmationState {
  final String message;
  const ConfirmationError(this.message);

  @override
  List<Object> get props => [message];
}

class ConfirmationGetLoaded extends ConfirmationState {
  final String successMessage;
  const ConfirmationGetLoaded(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class ResendEmilLoaded extends ConfirmationState {
  final String successMessage;
  const ResendEmilLoaded(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}
