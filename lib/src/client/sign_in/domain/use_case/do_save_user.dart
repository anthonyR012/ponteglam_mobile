import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/sign_in/domain/repository/sign_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoSaveUser {
  final SignInRepository signInRepository;

  DoSaveUser(this.signInRepository);

  Future<Either<Failure, UserModel>> call(
      {required ParamsDoSaveUser params}) async {
    if (params.dataFrom == Repository.local) {
      final token = params.user.token;
      final newUser = params.user.copyWith(token: "");
      var stateSavedLocal = await signInRepository.saveUser(
          user: newUser, datasource: params.dataFrom);
      if (stateSavedLocal.isRight()) {
        await params.prefs.setBool(keyLogin, true);
        await params.storage.write(key: keyAuthToken, value: token!);
        stateSavedLocal.replace(Right(newUser));
      }
      return stateSavedLocal;
    } else {
      return await signInRepository.saveUser(
          user: params.user, datasource: params.dataFrom);
    }
  }
}

class ParamsDoSaveUser {
  final UserModel user;
  final Repository dataFrom;
  final SharedPreferences prefs;
  final IStorage storage;
  ParamsDoSaveUser(
      {required this.prefs,
      required this.storage,
      required this.user,
      required this.dataFrom});
}
