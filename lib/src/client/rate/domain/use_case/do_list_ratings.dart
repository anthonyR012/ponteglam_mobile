import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';
import 'package:ponte_glam/src/client/rate/domain/repository/rating_repository.dart';

class DoListRatings {
  DoListRatings(this._repository);
  final RatingRepository _repository;

  Future<Either<Failure, List<RatingModel>>> call(
      int serviceId) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    if (authToken.isEmpty) return Left(Failure('No token found'));
    return _repository.listRatings(
      authToken: authToken,
      serviceId: serviceId,
    );
  }
}
