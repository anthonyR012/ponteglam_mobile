import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/rate/data/datasource/rating_datasource.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';
import 'package:ponte_glam/src/client/rate/domain/repository/rating_repository.dart';

class RatingRepositoryImpl extends RatingRepository {
  RatingRepositoryImpl(this._datasource);
  final RatingDatasource _datasource;

  @override
  Future<Either<Failure, List<RatingModel>>> listRatings({
    required String authToken,
    required int serviceId,
  }) async {
    try {
      final result = await _datasource.listRatings(
        authToken: authToken,
        serviceId: serviceId,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingModel>> createRating({
    required String authToken,
    required int serviceId,
    required int appointmentId,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await _datasource.createRating(
        authToken: authToken,
        serviceId: serviceId,
        appointmentId: appointmentId,
        rating: rating,
        comment: comment,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingModel>> replyRating({
    required String authToken,
    required int ratingId,
    required String reply,
  }) async {
    try {
      final result = await _datasource.replyRating(
        authToken: authToken,
        ratingId: ratingId,
        reply: reply,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

