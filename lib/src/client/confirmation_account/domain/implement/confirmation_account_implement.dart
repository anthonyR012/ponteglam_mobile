import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/confirmation_account/data/datasource/confirmation_account_datasource.dart';
import 'package:ponte_glam/src/client/confirmation_account/domain/repository/confirmation_account_repository.dart';

class ConfirmationAccountImplement extends ConfirmationAccountRepository {
  final ConfirmationAccountDatasource confirmationAccountDatasource;
  ConfirmationAccountImplement(this.confirmationAccountDatasource);

  @override
  Future<Either<Failure, String>> verifyEmail(
      {required String code, required String authToken}) async {
    try {
      String value = await confirmationAccountDatasource.verifyEmail(
          code: code, authToken: authToken);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendEmail(
      {required String authToken}) async {
    try {
      String value =
          await confirmationAccountDatasource.resendEmail(authToken: authToken);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
