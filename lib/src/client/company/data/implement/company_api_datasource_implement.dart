import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/src/client/company/data/datasource/company_datasource.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';

class CompanyApiDatasourceImplement implements CompanyApiDatasource {
  final Dio _dio;
  final EndPoints _endPoints;

  CompanyApiDatasourceImplement(this._dio, this._endPoints);

  @override
  Future<int> createCompany(CompanyFormModel form, String token) async {
    final Map<String, dynamic> data = {
      'name': form.companyName,
      'description': form.companyDescription,
      if (form.nequiNumber != null && form.nequiNumber!.isNotEmpty)
        'nequi_number': form.nequiNumber,
    };

    if (form.companyProfileImagePath != null &&
        await File(form.companyProfileImagePath!).exists()) {
      data['profile_image'] =
          await MultipartFile.fromFile(form.companyProfileImagePath!);
    }
    if (form.companyCoverImagePath != null &&
        await File(form.companyCoverImagePath!).exists()) {
      data['cover_image'] =
          await MultipartFile.fromFile(form.companyCoverImagePath!);
    }

    final formData = FormData.fromMap(data);
    final response = await _dio
        .post(
          _endPoints.createCompanyUrl,
          data: formData,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode == HTTP_201_CREATED ||
        response.statusCode == HTTP_200_OK) {
      return response.data['id'];
    }
    throw Exception('Error al crear la compañía: ${response.statusCode}');
  }

  @override
  Future<int> createHeadquarter(
      CompanyFormModel form, int companyId, String token) async {
    final Map<String, dynamic> data = {
      'name': form.headquarterName,
      'phone_number': form.headquarterPhone.isEmpty ? null : form.headquarterPhone,
      'address': form.headquarterAddress,
      'latitude':
          form.headquarterLatitude.isEmpty ? null : form.headquarterLatitude,
      'longitude':
          form.headquarterLongitude.isEmpty ? null : form.headquarterLongitude,
      'company': companyId,
      'city_id': form.cityId,
      'country': 1, // Default country ID
    };

    if (form.additionalImagesPaths.isNotEmpty) {
      List<MultipartFile> files = [];
      for (var path in form.additionalImagesPaths) {
        if (await File(path).exists()) {
          files.add(await MultipartFile.fromFile(path));
        }
      }
      data['additional_image'] = files;
    }

    final formData = FormData.fromMap(data);
    final response = await _dio
        .post(
          _endPoints.createHeadquarterUrl,
          data: formData,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode == HTTP_201_CREATED ||
        response.statusCode == HTTP_200_OK) {
      return response.data['id'];
    }
    throw Exception('Error al crear la sede: ${response.statusCode}');
  }

  @override
  Future<void> createTimeConfiguration(
      CompanyFormModel form, int headquarterId, String token) async {
    final Map<String, dynamic> data = {
      'headquarter_id': headquarterId,
      ...form.workHours,
    };

    final response = await _dio
        .post(
          _endPoints.createHeadquarterWeekdayTimeConfigurationUrl,
          data: data,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_201_CREATED &&
        response.statusCode != HTTP_200_OK) {
      throw Exception('Error al configurar horarios');
    }
  }
}
