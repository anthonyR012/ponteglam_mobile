import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/src/supplier/company/data/datasource/company_datasource.dart';
import 'package:ponte_glam/shared/model/company_model.dart';

class SupplierCompanyApiDatasource implements SupplierCompanyDatasource {
  final Dio _dio;
  final EndPoints _endPoints;

  SupplierCompanyApiDatasource(this._dio, this._endPoints);

  @override
  Future<void> updateCompany({
    required String authToken,
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  }) async {
    final headers = {HttpHeaders.authorizationHeader: 'token $authToken'};
    final Response response;

    if (profileImage != null && await profileImage.exists()) {
      final data = FormData.fromMap({
        'name': name,
        'description': description,
        'profile_image':
            await MultipartFile.fromFile(profileImage.path),
      });
      response = await _dio
          .patch(
            _endPoints.updateCompanyUrl(companyId),
            data: data,
            options: Options(headers: headers),
          )
          .timeout(const Duration(seconds: timeOutApi));
    } else {
      response = await _dio
          .patch(
            _endPoints.updateCompanyUrl(companyId),
            data: {'name': name, 'description': description},
            options: Options(headers: headers),
          )
          .timeout(const Duration(seconds: timeOutApi));
    }

    if (response.statusCode != HTTP_200_OK &&
        response.statusCode != HTTP_201_CREATED) {
      throw Exception(
          'Error al actualizar la compañía: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteCompany({
    required String authToken,
    required int companyId,
  }) async {
    final response = await _dio
        .delete(
          _endPoints.deleteCompanyUrl(companyId),
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK &&
        response.statusCode != HTTP_204_NO_CONTENT) {
      throw Exception(
          'Error al eliminar la compañía: ${response.statusCode}');
    }
  }

  @override
  Future<void> requestNequiUpdate({
    required String authToken,
    required int companyId,
  }) async {
    final headers = {HttpHeaders.authorizationHeader: 'token $authToken'};
    final response = await _dio
        .post(
          _endPoints.requestNequiUpdateUrl(companyId),
          options: Options(headers: headers),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK) {
      final msg = response.data is Map && response.data.containsKey('error')
          ? response.data['error']
          : 'Error al solicitar el código de verificación';
      throw Exception(msg);
    }
  }

  @override
  Future<CompanyModel> updateNequiNumber({
    required String authToken,
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  }) async {
    final headers = {HttpHeaders.authorizationHeader: 'token $authToken'};
    final response = await _dio
        .patch(
          _endPoints.updateNequiUrl(companyId),
          data: {
            'nequi_number': nequiNumber,
            'verification_code': verificationCode,
          },
          options: Options(headers: headers),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK) {
      final msg = response.data is Map && response.data.containsKey('error')
          ? response.data['error']
          : 'Error al actualizar el número de Nequi';
      throw Exception(msg);
    }

    final successData = response.data['success'];
    return CompanyModel.fromJson(successData);
  }
}
