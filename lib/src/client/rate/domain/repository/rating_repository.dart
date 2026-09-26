import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';

abstract class RatingRepository {
  Future<Either<Failure, List<RatingModel>>> listRatings({
    required String authToken,
    required int serviceId,
  });

  Future<Either<Failure, RatingModel>> createRating({
    required String authToken,
    required int serviceId,
    required int appointmentId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, RatingModel>> replyRating({
    required String authToken,
    required int ratingId,
    required String reply,
  });
}
