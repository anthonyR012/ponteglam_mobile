import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoSignUp {
  final SignUpRepository signUpRepository;

  DoSignUp(this.signUpRepository);

  Future<Either<Failure, UserModel>> call(
      {required ParamsDoSignUp params}) async {
    final stateNotification = await params.singInCubit.doInitNotificationCall();
    String tokenFcm = "";
    if (stateNotification.isRight()) {
      tokenFcm = stateNotification.getOrElse(() => "");
    }
    String typeDevice = PlatformType.web.name;
    String deviceId = "";
    if (Platform.isAndroid) {
      typeDevice = PlatformType.android.name;
      final androidInfo = await params.deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      typeDevice = PlatformType.ios.name;
      final iosInfo = await params.deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    }

    final user = params.user.copyWith(
        registrationId: tokenFcm, deviceId: deviceId, typeDevice: typeDevice);
    final state = await signUpRepository.signUp(user: user);
    if (state.isRight()) {
      params.signUpCubit.imageUpload = null;
    }
    return state;
  }
}

class ParamsDoSignUp {
  final UserModel user;
  final SignUpCubit signUpCubit;
  final SignInCubit singInCubit;
  final DeviceInfoPlugin deviceInfo;

  ParamsDoSignUp(
      {required this.user,
      required this.signUpCubit,
      required this.singInCubit,
      required this.deviceInfo});
}
