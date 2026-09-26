import 'dart:io';

import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/supplier/headquarter/data/datasource/headquarter_datasource.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';

class SupplierHeadquarterApiDatasource
    implements SupplierHeadquarterDatasource {
  final Dio _dio;
  final EndPoints _endPoints;

  SupplierHeadquarterApiDatasource(this._dio, this._endPoints);

  @override
  Future<void> deleteHeadquarter({
    required String authToken,
    required int headquarterId,
  }) async {
    final response = await _dio
        .delete(
          _endPoints.deleteHeadquarterUrl(headquarterId),
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK &&
        response.statusCode != HTTP_204_NO_CONTENT) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al eliminar la sede: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateHeadquarter({
    required String authToken,
    required int headquarterId,
    required HeadquarterFormModel form,
  }) async {
    final Map<String, dynamic> data = {};

    if (form.headquarterName.isNotEmpty) data['name'] = form.headquarterName;
    data['phone_number'] =
        form.headquarterPhone.isEmpty ? null : form.headquarterPhone;
    if (form.headquarterAddress.isNotEmpty) {
      data['address'] = form.headquarterAddress;
    }
    if (form.headquarterLatitude.isNotEmpty) {
      data['latitude'] = form.headquarterLatitude;
    }
    if (form.headquarterLongitude.isNotEmpty) {
      data['longitude'] = form.headquarterLongitude;
    }
    if (form.cityId != null) {
      data['city_id'] = form.cityId;
    }

    if (form.additionalImagesPaths.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final path in form.additionalImagesPaths) {
        if (await File(path).exists()) {
          files.add(await MultipartFile.fromFile(path));
        }
      }
      if (files.isNotEmpty) data['additional_image'] = files;
    }

    final formData = FormData.fromMap(data);
    final response = await _dio
        .patch(
          _endPoints.updateHeadquarterUrl(headquarterId),
          data: formData,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al actualizar la sede: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, String>> getWeekConfiguration({
    required String authToken,
    required int headquarterId,
  }) async {
    final response = await _dio
        .get(
          _endPoints.getWeekConfigurationHeadquarterUrl(headquarterId),
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode == HTTP_200_OK) {
      final raw = response.data['success'] as Map<String, dynamic>? ?? {};
      return raw.map((k, v) => MapEntry(k, v.toString()));
    }
    if (response.data is Map) {
      final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
      if (errorMsg != null) throw Exception(errorMsg);
    }
    throw Exception(
        'Error al obtener la configuración de horarios: ${response.statusCode}');
  }
}
