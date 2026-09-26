import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';

abstract class CompanyApiDatasource {
  Future<int> createCompany(CompanyFormModel form, String token);
  Future<int> createHeadquarter(
      CompanyFormModel form, int companyId, String token);
  Future<void> createTimeConfiguration(
      CompanyFormModel form, int headquarterId, String token);
}
