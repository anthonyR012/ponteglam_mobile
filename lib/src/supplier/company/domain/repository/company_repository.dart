import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/company_model.dart';

abstract class SupplierCompanyRepository {
  Future<Either<Failure, Unit>> updateCompany({
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  });

  Future<Either<Failure, Unit>> deleteCompany({
    required int companyId,
  });

  Future<Either<Failure, Unit>> requestNequiUpdate({
    required int companyId,
  });

  Future<Either<Failure, CompanyModel>> updateNequiNumber({
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  });
}
