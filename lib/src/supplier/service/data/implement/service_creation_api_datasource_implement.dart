import 'dart:io';

import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/supplier/service/data/datasource/service_creation_datasource.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';

class ServiceCreationApiDatasourceImplement extends ServiceCreationDatasource {
  ServiceCreationApiDatasourceImplement(this._dio, this._endPoints);

  final Dio _dio;
  final EndPoints _endPoints;

  @override
  Future<int> createService({
    required String authToken,
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    final Map<String, dynamic> fields = {
      'name': form.name,
      'description': form.description,
      'confirmation_in': form.confirmationIn,
      'remember_in': form.rememberIn,
      'only_home_service': form.onlyHomeService,
      if (form.onlyHomeService && form.homeServicePrice != null)
        'home_service_price': form.homeServicePrice,
      'price': form.price,
      'headquarter_id': headquarterId,
      if (form.stateId != null) 'state': form.stateId,
      if (form.genderId != null) 'gender': form.genderId,
      if (form.serviceCategoryId != null)
        'service_category': form.serviceCategoryId,
      if (form.amenityIds.isNotEmpty) 'amenities': form.amenityIds,
    };

    if (form.imagePaths.isNotEmpty) {
      final List<MultipartFile> images = [];
      for (final path in form.imagePaths) {
        if (await File(path).exists()) {
          images.add(await MultipartFile.fromFile(path));
        }
      }
      if (images.isNotEmpty) fields['service_image'] = images;
    }

    final FormData formData = FormData.fromMap(fields);

    final Response response = await _dio
        .post(
          _endPoints.createServiceUrl,
          data: formData,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'token $authToken'},
          ),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == HTTP_201_CREATED ||
        response.statusCode == HTTP_200_OK) {
      return response.data['service_id'] as int;
    }
    if (response.data is Map) {
      final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
      if (errorMsg != null) throw Exception(errorMsg);
    }
    throw Exception('Error al crear el servicio: ${response.statusCode}');
  }

  @override
  Future<int> updateService({
    required String authToken,
    required int serviceId,
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    final Map<String, dynamic> fields = {
      'name': form.name,
      'description': form.description,
      'confirmation_in': form.confirmationIn,
      'remember_in': form.rememberIn,
      'only_home_service': form.onlyHomeService,
      if (form.onlyHomeService && form.homeServicePrice != null)
        'home_service_price': form.homeServicePrice,
      'price': form.price,
      'headquarter_id': headquarterId,
      if (form.stateId != null) 'state': form.stateId,
      if (form.genderId != null) 'gender': form.genderId,
      if (form.serviceCategoryId != null)
        'service_category': form.serviceCategoryId,
      if (form.amenityIds.isNotEmpty) 'amenities': form.amenityIds,
    };

    if (form.imagePaths.isNotEmpty) {
      final List<MultipartFile> images = [];
      for (final path in form.imagePaths) {
        if (await File(path).exists()) {
          images.add(await MultipartFile.fromFile(path));
        }
      }
      if (images.isNotEmpty) fields['service_image'] = images;
    }

    final FormData formData = FormData.fromMap(fields);

    final Response response = await _dio
        .put(
          '${_endPoints.updateServiceUrl}$serviceId/',
          data: formData,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'token $authToken'},
          ),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == HTTP_200_OK) {
      return response.data['service_id'] as int;
    }
    if (response.data is Map) {
      final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
      if (errorMsg != null) throw Exception(errorMsg);
    }
    throw Exception('Error al actualizar el servicio: ${response.statusCode}');
  }

  @override
  Future<void> deleteService({
    required String authToken,
    required int serviceId,
  }) async {
    final Response response = await _dio
        .delete(
          _endPoints.deleteServiceUrl(serviceId),
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'token $authToken'},
          ),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == HTTP_200_OK ||
        response.statusCode == HTTP_204_NO_CONTENT) {
      return;
    }
    if (response.data is Map) {
      final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
      if (errorMsg != null) throw Exception(errorMsg);
    }
    throw Exception('Error al eliminar el servicio: ${response.statusCode}');
  }
}
