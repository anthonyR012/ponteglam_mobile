import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart';

class DoRequestNequiUpdate {
  final SupplierCompanyRepository _repository;
  DoRequestNequiUpdate(this._repository);

  Future<Either<Failure, Unit>> call({
    required int companyId,
  }) {
    return _repository.requestNequiUpdate(
      companyId: companyId,
    );
  }
}
