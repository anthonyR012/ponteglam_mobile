import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/home/data/datasource/home_datasource.dart';
import 'package:ponte_glam/src/client/home/domain/repository/home_repository.dart';

class HomeImplement extends HomeRepository {
  final HomeApiDatasource homeDatasource;

  HomeImplement(this.homeDatasource);

  @override
  Future<Either<Failure, PaginatorServiceModel>> getServices(
      {required String authToken,
      required Position position,
       required FilterServiceModel filter}) async {
    try {
      PaginatorServiceModel value = await homeDatasource.getServices(
          authToken: authToken,
          position: position,
          filter: filter);
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
