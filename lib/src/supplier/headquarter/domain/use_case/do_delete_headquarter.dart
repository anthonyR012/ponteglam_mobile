import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/repository/headquarter_repository.dart';

class DoDeleteHeadquarter {
  final SupplierHeadquarterRepository _repository;
  DoDeleteHeadquarter(this._repository);

  Future<Either<Failure, Unit>> call({required int headquarterId}) {
    return _repository.deleteHeadquarter(headquarterId: headquarterId);
  }
}
