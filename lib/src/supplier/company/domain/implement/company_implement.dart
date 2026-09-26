import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/supplier/company/data/datasource/company_datasource.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart';
import 'package:ponte_glam/shared/model/company_model.dart';

class SupplierCompanyImplement implements SupplierCompanyRepository {
  final SupplierCompanyDatasource _datasource;
  final IStorage _storage;

  SupplierCompanyImplement({
    required SupplierCompanyDatasource datasource,
    required IStorage storage,
  })  : _datasource = datasource,
        _storage = storage;

  @override
  Future<Either<Failure, Unit>> updateCompany({
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      await _datasource.updateCompany(
        authToken: token,
        companyId: companyId,
        name: name,
        description: description,
        profileImage: profileImage,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCompany({
    required int companyId,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      await _datasource.deleteCompany(
          authToken: token, companyId: companyId);
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestNequiUpdate({
    required int companyId,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      await _datasource.requestNequiUpdate(
        authToken: token,
        companyId: companyId,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompanyModel>> updateNequiNumber({
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      final updatedCompany = await _datasource.updateNequiNumber(
        authToken: token,
        companyId: companyId,
        nequiNumber: nequiNumber,
        verificationCode: verificationCode,
      );
      return Right(updatedCompany);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
