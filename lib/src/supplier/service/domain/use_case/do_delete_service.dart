import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/service/domain/repository/service_creation_repository.dart';

class DoDeleteService {
  final ServiceCreationRepository repository;

  DoDeleteService(this.repository);

  Future<Either<Failure, Unit>> call({required int serviceId}) {
    return repository.deleteService(serviceId: serviceId);
  }
}
