import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/company_model.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart';

class DoUpdateNequiNumber {
  final SupplierCompanyRepository _repository;
  DoUpdateNequiNumber(this._repository);

  Future<Either<Failure, CompanyModel>> call({
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  }) {
    return _repository.updateNequiNumber(
      companyId: companyId,
      nequiNumber: nequiNumber,
      verificationCode: verificationCode,
    );
  }
}
