import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';

abstract class CompanyRepository {
  Future<Either<Failure, int>> createCompany(CompanyFormModel form);
  Future<Either<Failure, int>> createHeadquarter(
      CompanyFormModel form, int companyId);
  Future<Either<Failure, Unit>> createTimeConfiguration(
      CompanyFormModel form, int headquarterId);
}
