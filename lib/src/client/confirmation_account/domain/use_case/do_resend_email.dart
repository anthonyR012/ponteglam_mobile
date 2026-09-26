import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/confirmation_account/domain/repository/confirmation_account_repository.dart';

class DoResendEmail {
  final ConfirmationAccountRepository confirmationRepository;
  DoResendEmail(this.confirmationRepository);

  Future<Either<Failure, String>> call({required String authToken}) async {
    return await confirmationRepository.resendEmail(authToken: authToken);
  }
}
