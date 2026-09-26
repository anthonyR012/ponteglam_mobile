part of 'recover_cubit.dart';

sealed class RecoverState extends Equatable {
  const RecoverState();

  @override
  List<Object> get props => [];
}

final class RecoverInitial extends RecoverState {}

class RecoverIsLoading extends RecoverState {}

class RecoverError extends RecoverState {
  final String message;

  const RecoverError(this.message);

  @override
  List<Object> get props => [message];
}

class EmailSended extends RecoverState {
  final String sucess;

  const EmailSended(this.sucess);
  @override
  List<Object> get props => [sucess];
}

class CodeVerified extends RecoverState {
  final UserModel user;

  const CodeVerified(this.user);
  @override
  List<Object> get props => [user];
}

class RecoverPassGetLoaded extends RecoverState {
  final String message;
  const RecoverPassGetLoaded(this.message);

  @override
  List<Object> get props => [message];
}
