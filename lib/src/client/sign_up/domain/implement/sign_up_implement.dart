import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/sign_up/data/datasource/sign_up_datasource.dart';
import 'package:ponte_glam/src/client/sign_up/domain/repository/sign_up_repository.dart';

class SingUpImplement extends SignUpRepository {
  final SignUpDatasource signUpDatasource;

  SingUpImplement(this.signUpDatasource);

  @override
  Future<Either<Failure, UserModel>> signUp({required UserModel user}) async {
    try {
      UserModel newUser = await signUpDatasource.signUp(user: user);
      return Right(newUser);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
