part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class SplashIsLoading extends SplashState {}

class SplashError extends SplashState {
  final String messageError;
  const SplashError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

final class SplashInitCompleted extends SplashState {}

final class AlreadyLogin extends SplashState {
  final UserModel user;
  const AlreadyLogin(this.user);

  @override
  List<Object> get props => [user];
}

final class FistTimeInit extends SplashState {}

