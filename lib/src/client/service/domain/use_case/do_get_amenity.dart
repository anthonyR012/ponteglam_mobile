import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/src/client/service/domain/repository/service_repository.dart';

class DoGetAmenity {
  final ServiceRepository serviceRepository;

  DoGetAmenity(this.serviceRepository);

  Future<Either<Failure, AmenityModel>> call({required int amenityId}) async {
    return await serviceRepository.getAmenity(amenityId: amenityId);
  }
}
