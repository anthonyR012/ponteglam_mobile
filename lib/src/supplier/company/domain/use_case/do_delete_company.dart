import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart';

class DoDeleteCompany {
  final SupplierCompanyRepository _repository;
  DoDeleteCompany(this._repository);

  Future<Either<Failure, Unit>> call({required int companyId}) {
    return _repository.deleteCompany(companyId: companyId);
  }
}
