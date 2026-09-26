import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, PaginatorServiceModel>> getServices(
      {required String authToken,
      required Position position,
      required FilterServiceModel filter});
}
