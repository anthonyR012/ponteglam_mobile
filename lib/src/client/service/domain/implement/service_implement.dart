import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/src/client/service/data/implement/service_local_datasource.dart';
import 'package:ponte_glam/src/client/service/domain/repository/service_repository.dart';

class ServiceImplement extends ServiceRepository {
  final ServiceLocalDatasourceImplement serviceLocalDatasource;

  ServiceImplement(this.serviceLocalDatasource);

  @override
  Future<Either<Failure, AmenityModel>> getAmenity(
      {required int amenityId}) async {
    try {
      AmenityModel amenity =
          await serviceLocalDatasource.getAminity(amenityId: amenityId);
      return Right(amenity);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
