import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

abstract class RecoverPassRepository {
  Future<Either<Failure, UserModel>> sendVerifyCode(
      {required String email, required String code});
  Future<Either<Failure, String>> sendEmailVerify({required String email});
  Future<Either<Failure, String>> updatePassword(
      {required String newPassword, required String authToken});
}
