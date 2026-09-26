import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoSignIn {
  final SignInRepository signInRepository;

  DoSignIn(this.signInRepository);

  Future<Either<Failure, UserModel>> call(
      {required ParamsDoSignIn params}) async {
    if (params.repository == Repository.firebase) {
      final stateFirebase = await signInRepository.signIn(
          datasource: params.repository,
          userName: params.userName,
          password: params.password);
      if (stateFirebase.isLeft()) return stateFirebase;
      String tokenFcm = "";
      final stateNotification = await params.doInitNotification();
      if (stateNotification.isRight()) {
        tokenFcm = stateNotification.getOrElse(() => "");
      }
      UserModel user =
          stateFirebase.getOrElse(() => UserModel.fromJson(const {}));
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
      user = user.copyWith(
          registrationId: tokenFcm,
          deviceId: deviceId,
          typeDevice: typeDevice,
          hasAcceptedTerms: params.acceptedTerms);
      final stateInsertApi = await signInRepository.saveUser(
          user: user, datasource: Repository.api);
      if (stateInsertApi.isLeft()) return stateInsertApi;
      final userInserted = stateInsertApi.foldRight(user, (r, previous) => r);

      await params.prefs.setBool(keyLogin, true);
      final token = userInserted.token ?? "";
      await params.storage.write(key: keyAuthToken, value: token);

      final fcmResult =
          await signInRepository.registerFcmToken(authToken: token);
      fcmResult.fold(
        (failure) => catchError(failure.message, 'DoSignIn.firebase'),
        (_) {},
      );

      final response = await signInRepository.saveUser(
          user: userInserted, datasource: Repository.local);
      return response;
    } else {
      final stateApi = await signInRepository.signIn(
          datasource: params.repository,
          userName: params.userName,
          password: params.password);
      if (stateApi.isLeft()) return stateApi;
      UserModel user = stateApi.getOrElse(() => UserModel.fromJson(const {}));
      UserModel newUser = user;
      if (user.emailVerified ?? true) {
        await params.prefs.setBool(keyLogin, true);
        final token = user.token ?? "";
        await params.storage.write(key: keyAuthToken, value: token);

        final fcmResult =
            await signInRepository.registerFcmToken(authToken: token);
        fcmResult.fold(
          (failure) => catchError(failure.message, 'DoSignIn.api'),
          (_) {},
        );

        newUser = user.copyWith(token: "");
      }
      return await signInRepository.saveUser(
          user: newUser, datasource: Repository.local);
    }
  }
}

class ParamsDoSignIn {
  final String? userName;
  final String? password;
  final SharedPreferences prefs;
  final IStorage storage;
  final Repository repository;
  final DeviceInfoPlugin deviceInfo;
  final Future<Either<Failure, String>> Function() doInitNotification;
  final bool acceptedTerms;

  ParamsDoSignIn(this.userName, this.password, this.prefs, this.storage,
      this.repository, this.deviceInfo, this.doInitNotification,
      {this.acceptedTerms = false});
}
