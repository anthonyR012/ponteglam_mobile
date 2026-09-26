import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';

abstract class ServiceRepository {
  Future<Either<Failure, AmenityModel>> getAmenity({required int amenityId});
}
