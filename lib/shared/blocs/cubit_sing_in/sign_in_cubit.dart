import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.loginCall, this.logoutCall, this.saveUserCall,
      this.getUserCall, this.doInitNotificationCall, this.doRegisterDeviceCall)
      : super(SignInInitial());

  final DoSignIn loginCall;
  final DoSignOut logoutCall;
  final DoSaveUser saveUserCall;
  final DoGetUser getUserCall;
  final DoInitNotification doInitNotificationCall;
  final DoRegisterDevice doRegisterDeviceCall;

  void doSignIn(
      {String? userName,
      String? password,
      required Repository repository,
      bool acceptedTerms = false}) async {
    emit(SignInIsLoading());
    ParamsDoSignIn params = ParamsDoSignIn(
        userName,
        password,
        getIt<SharedPreferences>(),
        getIt<IStorage>(),
        repository,
        getIt<DeviceInfoPlugin>(),
        doInitNotificationCall.call,
        acceptedTerms: acceptedTerms);
    final failureOrUser = await loginCall(params: params);
    final signInState = _failureOrSucess<UserModel>(
        failureOrUser, (user) => SignInGetLoaded(user));
    emit(signInState);

    // Registrar el dispositivo FCM en background tras cualquier login exitoso
    if (signInState is SignInGetLoaded) {
      unawaited(doInitNotificationCall());
      unawaited(doRegisterDeviceCall());
    }
  }

  void doSingOut() async {
    emit(SignInIsLoading());
    final ParamsDoSignOut params = ParamsDoSignOut(
        getIt<SharedPreferences>(),
        getIt<IStorage>(),
        getIt<SettingBloc>(),
        getIt<HomeBloc>(),
        getIt<ServiceBloc>(),
        getIt<HeadquarterCubit>());
    final failureOrBool = await logoutCall(params: params);
    emit(_failureOrSucess<bool>(failureOrBool, (out) => SignOutGetLoaded(out)));
  }

  void doSaveUser(
      {required UserModel user, required Repository dataFrom}) async {
    emit(SignInIsLoading());
    ParamsDoSaveUser params = ParamsDoSaveUser(
        prefs: getIt<SharedPreferences>(),
        storage: getIt<IStorage>(),
        dataFrom: dataFrom,
        user: user);
    final failureOrUser = await saveUserCall(params: params);
    emit(_failureOrSucess<UserModel>(
        failureOrUser, (user) => SignInGetLoaded(user)));
  }

  void doGetUser({required UserModel user}) async {
    emit(SignInIsLoading());
    final failureOrGetUser = await getUserCall();
    emit(_failureOrSucess<UserModel>(
        failureOrGetUser, (user) => GetUserLoaded(user)));
  }

  void doInitNotification() async {
    emit(SignInIsLoading());
    final failureOrSucess = await doInitNotificationCall();
    emit(_failureOrSucess<String>(
        failureOrSucess, (success) => InitNotificationLoaded(success)));
  }

  void resetState() {
    emit(SignInInitial());
  }

  void setState(SignInState state) {
    emit(state);
  }

  SignInState _failureOrSucess<T>(
      Either<Failure, T> failureOrSucess, SignInState Function(T) onSuccess) {
    return failureOrSucess.fold(
        (failure) => SignInError(failure.message), onSuccess);
  }
}
