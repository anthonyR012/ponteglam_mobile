part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInIsLoading extends SignInState {}

class SignInGetLoaded extends SignInState {
  final UserModel user;
  const SignInGetLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class SignOutGetLoaded extends SignInState {
  final bool result;
  const SignOutGetLoaded(this.result);
  @override
  List<Object> get props => [result];
}

class SaveUserGetLoaded extends SignInState {
  final UserModel user;
  const SaveUserGetLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class SignInError extends SignInState {
  final String messageError;

  const SignInError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

class GetUserLoaded extends SignInState {
  final UserModel user;
  const GetUserLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class InitNotificationLoaded extends SignInState {
  final String token;
  const InitNotificationLoaded(this.token);
}
