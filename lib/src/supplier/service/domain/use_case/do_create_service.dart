import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';
import 'package:ponte_glam/src/supplier/service/domain/repository/service_creation_repository.dart';

class DoCreateService {
  final ServiceCreationRepository repository;

  DoCreateService(this.repository);

  Future<Either<Failure, int>> call({
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    return await repository.createService(
      form: form,
      headquarterId: headquarterId,
    );
  }
}
