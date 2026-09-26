import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/recover_password/domain/repository/recover_pass_repository.dart';

class DoRecoverVerifyCode {
  final RecoverPassRepository recoverPassRepository;

  DoRecoverVerifyCode(this.recoverPassRepository);

  Future<Either<Failure, UserModel>> call(
      {required String code, required String email}) async {
    return await recoverPassRepository.sendVerifyCode(email: email, code: code);
  }
}
