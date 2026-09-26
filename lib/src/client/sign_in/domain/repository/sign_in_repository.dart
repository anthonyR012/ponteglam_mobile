import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

abstract class SignInRepository {
  Future<Either<Failure, bool>> signOut({required Repository datasource});
  Future<Either<Failure, UserModel>> signIn(
      {String? userName, String? password, required Repository datasource});
  Future<Either<Failure, UserModel>> saveUser(
      {required UserModel user, required Repository datasource});
  Future<Either<Failure, void>> registerFcmToken({required String authToken});
  Future<Either<Failure, void>> deleteFcmToken({
    required String authToken,
    required String fcmToken,
  });
}
