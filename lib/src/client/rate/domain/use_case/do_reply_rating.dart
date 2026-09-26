import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';
import 'package:ponte_glam/src/client/rate/domain/repository/rating_repository.dart';

import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';

class ParamsDoReplyRating {
  ParamsDoReplyRating({
    required this.ratingId,
    required this.reply,
  });

  final int ratingId;
  final String reply;
}

class DoReplyRating {
  DoReplyRating(this.repository);

  final RatingRepository repository;

  Future<Either<Failure, RatingModel>> call(ParamsDoReplyRating params) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    if (authToken.isEmpty) return Left(Failure('No token found'));

    return await repository.replyRating(
      authToken: authToken,
      ratingId: params.ratingId,
      reply: params.reply,
    );
  }
}
