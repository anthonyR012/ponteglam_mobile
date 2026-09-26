import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

abstract class SignUpRepository {
  Future<Either<Failure, UserModel>> signUp({required UserModel user});
}
