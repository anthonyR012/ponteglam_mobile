import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';

abstract class ServiceCreationRepository {
  Future<Either<Failure, int>> createService({
    required ServiceCreationFormModel form,
    required int headquarterId,
  });

  Future<Either<Failure, int>> updateService({
    required int serviceId,
    required ServiceCreationFormModel form,
    required int headquarterId,
  });

  Future<Either<Failure, Unit>> deleteService({
    required int serviceId,
  });
}
