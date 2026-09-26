import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/headquarter/data/datasource/headquarter_datasource.dart';
import 'package:ponte_glam/src/client/headquarter/domain/repository/headquarter_repository.dart';

class HeadquarterImplement extends HeadquarterRepository {
  final HeadquarterDatasource headquarterDatasource;
  HeadquarterImplement(this.headquarterDatasource);

  @override
  Future<Either<Failure, String>> like(
      {required String authToken, required int headquarterCompanyId}) async {
    try {
      String value = await headquarterDatasource.like(
          authToken: authToken, headquarterCompanyId: headquarterCompanyId);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> dislike(
      {required String authToken, required int headquarterCompanyId}) async {
    try {
      String value = await headquarterDatasource.dislike(
          authToken: authToken, headquarterCompanyId: headquarterCompanyId);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
