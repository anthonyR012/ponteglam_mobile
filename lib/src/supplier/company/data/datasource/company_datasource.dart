import 'dart:io';
import 'package:ponte_glam/shared/model/company_model.dart';

abstract class SupplierCompanyDatasource {
  Future<void> updateCompany({
    required String authToken,
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  });

  Future<void> deleteCompany({
    required String authToken,
    required int companyId,
  });

  Future<void> requestNequiUpdate({
    required String authToken,
    required int companyId,
  });

  Future<CompanyModel> updateNequiNumber({
    required String authToken,
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  });
}
