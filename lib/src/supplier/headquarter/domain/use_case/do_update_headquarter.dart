import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/repository/headquarter_repository.dart';

class DoUpdateHeadquarter {
  final SupplierHeadquarterRepository _repository;

  DoUpdateHeadquarter(this._repository);

  Future<Either<Failure, Unit>> call({
    required int headquarterId,
    required HeadquarterFormModel form,
  }) =>
      _repository.updateHeadquarter(headquarterId: headquarterId, form: form);
}
