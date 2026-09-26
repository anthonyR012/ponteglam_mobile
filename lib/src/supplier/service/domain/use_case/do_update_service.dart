import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';
import 'package:ponte_glam/src/supplier/service/domain/repository/service_creation_repository.dart';

class DoUpdateService {
  final ServiceCreationRepository repository;

  DoUpdateService(this.repository);

  Future<Either<Failure, int>> call({
    required int serviceId,
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    return await repository.updateService(
      serviceId: serviceId,
      form: form,
      headquarterId: headquarterId,
    );
  }
}
