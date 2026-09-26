import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';

abstract class RatingDatasource {
  Future<List<RatingModel>> listRatings({
    required String authToken,
    required int serviceId,
  });

  Future<RatingModel> createRating({
    required String authToken,
    required int serviceId,
    required int appointmentId,
    required int rating,
    required String comment,
  });

  Future<RatingModel> replyRating({
    required String authToken,
    required int ratingId,
    required String reply,
  });
}

abstract class RatingApiDatasource extends RatingDatasource {}
