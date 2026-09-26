import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/modules_dp.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoInitApp {
  DoInitApp();

  Future<Either<Failure, SplashState>> call(
      {required BuildContext context}) async {
    try {
      injectBuildDependencies(context);
      final preferences = getIt<SharedPreferences>();
      bool alreadyLogin = preferences.getBool(keyLogin) ?? false;
      bool firstTime = preferences.getBool(keyInitApp) ?? true;

      //init user already logged
      if (alreadyLogin) {
        try {
          await getIt<SignInCubit>().doInitNotificationCall();
          await getIt<SignInCubit>().doRegisterDeviceCall();
        } catch (_) {}

        final stateUser = await getIt<SignInCubit>().getUserCall();
        UserModel? user;
        if (stateUser.isRight()) {
          user = stateUser.foldRight<UserModel?>(null, (r, previous) {
            return r;
          });
        }
        return Right(AlreadyLogin(user ?? UserModel.fromJson(const {})));
      }
      //first time open app
      if (firstTime) {
        return Right(FistTimeInit());
      }
      //init app to login
      return Right(SplashInitCompleted());
    } catch (e, stackTrace) {
      catchError(e.toString(), stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }
}
