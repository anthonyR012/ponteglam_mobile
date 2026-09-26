part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpIsLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String messageError;
  const SignUpError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

class SignUpGetLoaded extends SignUpState {
  final UserModel user;
  const SignUpGetLoaded(this.user);
  @override
  List<Object> get props => [user];
}
