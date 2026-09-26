import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/recover_password/domain/repository/recover_pass_repository.dart';
import 'package:ponte_glam/src/client/sign_in/domain/use_case/do_save_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoUpdatePassword {
  final RecoverPassRepository recoverPassRepository;
  DoUpdatePassword(this.recoverPassRepository);

  Future<Either<Failure, String>> call(
      {required ParamsDoUpdatePassword params}) async {
    final stateUpdated = await recoverPassRepository.updatePassword(
        newPassword: params.user.password ?? "",
        authToken: params.user.token ?? "");
    if (stateUpdated.isRight()) {
      final paramsDoSave = ParamsDoSaveUser(
          prefs: params.prefs,
          storage: params.storage,
          user: params.user,
          dataFrom: Repository.local);
      final stateInserted =
          await params.saveUserCall.call(params: paramsDoSave);
      if (stateInserted.isLeft()) {
        Failure leftValue = stateInserted.fold(
          (left) => left,
          (right) => null,
        )!;
        return Left(leftValue);
      }
    }
    return stateUpdated;
  }
}

class ParamsDoUpdatePassword {
  final UserModel user;
  final SharedPreferences prefs;
  final IStorage storage;
  final DoSaveUser saveUserCall;

  ParamsDoUpdatePassword(
      {required this.prefs,
      required this.storage,
      required this.saveUserCall,
      required this.user});
}
