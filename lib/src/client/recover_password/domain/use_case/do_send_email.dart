import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/recover_password/domain/repository/recover_pass_repository.dart';

class DoRecoverSendEmail {
  final RecoverPassRepository recoverPassRepository;

  DoRecoverSendEmail(this.recoverPassRepository);

  Future<Either<Failure, String>> call({required String email}) async {
    return await recoverPassRepository.sendEmailVerify(email: email);
  }
}
