import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/client/company/data/datasource/company_datasource.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/domain/repository/company_repository.dart';

class CompanyRepositoryImplement implements CompanyRepository {
  final CompanyApiDatasource datasource;
  final IStorage storage;

  CompanyRepositoryImplement({required this.datasource, required this.storage});

  @override
  Future<Either<Failure, int>> createCompany(CompanyFormModel form) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? "";
      final id = await datasource.createCompany(form, token);
      return Right(id);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> createHeadquarter(
      CompanyFormModel form, int companyId) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? "";
      final id = await datasource.createHeadquarter(form, companyId, token);
      return Right(id);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createTimeConfiguration(
      CompanyFormModel form, int headquarterId) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? "";
      await datasource.createTimeConfiguration(form, headquarterId, token);
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
