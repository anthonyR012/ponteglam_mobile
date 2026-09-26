import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/domain/repository/company_repository.dart';

class DoCreateCompany {
  final CompanyRepository repository;
  DoCreateCompany(this.repository);

  Future<Either<Failure, int>> call(CompanyFormModel form) async {
    return await repository.createCompany(form);
  }
}

class DoCreateHeadquarter {
  final CompanyRepository repository;
  DoCreateHeadquarter(this.repository);

  Future<Either<Failure, int>> call(
      CompanyFormModel form, int companyId) async {
    return await repository.createHeadquarter(form, companyId);
  }
}

class DoCreateTimeConfig {
  final CompanyRepository repository;
  DoCreateTimeConfig(this.repository);

  Future<Either<Failure, Unit>> call(
      CompanyFormModel form, int headquarterId) async {
    return await repository.createTimeConfiguration(form, headquarterId);
  }
}
