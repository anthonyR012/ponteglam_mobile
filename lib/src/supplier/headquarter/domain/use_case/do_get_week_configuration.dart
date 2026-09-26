import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/repository/headquarter_repository.dart';

class DoGetWeekConfiguration {
  final SupplierHeadquarterRepository _repository;

  DoGetWeekConfiguration(this._repository);

  Future<Either<Failure, Map<String, String>>> call({
    required int headquarterId,
  }) =>
      _repository.getWeekConfiguration(headquarterId: headquarterId);
}
