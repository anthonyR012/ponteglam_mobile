import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';

abstract class HeadquarterRepository {
  Future<Either<Failure, String>> like(
      {required String authToken, required int headquarterCompanyId});
  Future<Either<Failure, String>> dislike(
      {required String authToken, required int headquarterCompanyId});
}
