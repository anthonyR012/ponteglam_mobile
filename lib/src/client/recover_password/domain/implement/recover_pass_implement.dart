import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/recover_password/data/datasource/recover_pass_datasource.dart';
import 'package:ponte_glam/src/client/recover_password/domain/repository/recover_pass_repository.dart';

class RecoverPassImplement extends RecoverPassRepository {
  final RecoverPassDatasource recoverPasswordDatasource;

  RecoverPassImplement(this.recoverPasswordDatasource);

  @override
  Future<Either<Failure, String>> sendEmailVerify(
      {required String email}) async {
    try {
      String value =
          await recoverPasswordDatasource.sendEmailVerify(email: email);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> sendVerifyCode(
      {required String email, required String code}) async {
    try {
      UserModel userModel = await recoverPasswordDatasource.sendVerifyCode(
          email: email, code: code);
      return Right(userModel);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword(
      {required String newPassword, required String authToken}) async {
    try {
      String value = await recoverPasswordDatasource.updatePassword(
          newPassword: newPassword, authToken: authToken);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
