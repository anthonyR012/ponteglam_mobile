import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/company/domain/repository/company_repository.dart';

class DoUpdateCompany {
  final SupplierCompanyRepository _repository;
  DoUpdateCompany(this._repository);

  Future<Either<Failure, Unit>> call({
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  }) {
    return _repository.updateCompany(
      companyId: companyId,
      name: name,
      description: description,
      profileImage: profileImage,
    );
  }
}
