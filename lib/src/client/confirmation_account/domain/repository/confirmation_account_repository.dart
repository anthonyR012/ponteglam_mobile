import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';

abstract class ConfirmationAccountRepository {
  Future<Either<Failure, String>> verifyEmail(
      {required String code, required String authToken});
  Future<Either<Failure, String>> resendEmail({required String authToken});
}
