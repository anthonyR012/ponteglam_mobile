import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/src/supplier/worker/data/datasource/worker_datasource.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/worker_block_model.dart';

class WorkerApiDatasource implements WorkerDatasource {
  final Dio _dio;
  final EndPoints _endPoints;

  WorkerApiDatasource(this._dio, this._endPoints);

  @override
  Future<List<StaffMemberModel>> getStaff({
    required String authToken,
    required int headquarterId,
  }) async {
    final response = await _dio
        .get(
          _endPoints.listStaffUrl(headquarterId),
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode == HTTP_200_OK) {
      final List data = response.data['success'];
      return data.map((e) => StaffMemberModel.fromJson(e)).toList();
    }

    if (response.data is Map) {
      final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
      if (errorMsg != null) throw Exception(errorMsg);
    }
    throw Exception('Error al obtener staff: ${response.statusCode}');
  }

  @override
  Future<void> onboardWorker({
    required String authToken,
    required int headquarterId,
    required bool isAnonymous,
    String? name,
    String? email,
    String? phone,
  }) async {
    final Map<String, dynamic> data = {
      'headquarter_id': headquarterId,
      'is_anonymous': isAnonymous,
    };
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;

    final response = await _dio
        .post(
          _endPoints.onboardWorkerUrl,
          data: data,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_201_CREATED) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al registrar trabajador: ${response.statusCode}');
    }
  }

  @override
  Future<void> linkService({
    required String authToken,
    required int workerId,
    required int serviceId,
  }) async {
    final response = await _dio
        .post(
          _endPoints.linkWorkerServiceUrl(workerId),
          data: {'service_id': serviceId},
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al vincular servicio: ${response.statusCode}');
    }
  }

  @override
  Future<String?> unlinkService({
    required String authToken,
    required int workerId,
    required int serviceId,
  }) async {
    final response = await _dio
        .post(
          _endPoints.unlinkWorkerServiceUrl(workerId),
          data: {'service_id': serviceId},
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK &&
        response.statusCode != HTTP_202_ACCEPTED) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al desvincular servicio: ${response.statusCode}');
    }

    if (response.data['status'] == 'pending_removal') {
      final detail = response.data['detail'] ?? '';
      return 'El retiro se completará automáticamente después de las citas pendientes.\n\n$detail';
    }

    return response.data['message'] ?? response.data['detail'];
  }

  @override
  Future<void> addBlock({
    required String authToken,
    required int workerId,
    required WorkerBlockModel block,
  }) async {
    final response = await _dio
        .post(
          _endPoints.addWorkerBlockUrl(workerId),
          data: block.toJson(),
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_201_CREATED) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception('Error al bloquear horario: ${response.statusCode}');
    }
  }

  @override
  Future<void> removeFromHq({
    required String authToken,
    required int workerId,
    required int headquarterId,
  }) async {
    final response = await _dio
        .post(
          _endPoints.removeWorkerFromHqUrl(workerId),
          data: {'headquarter_id': headquarterId},
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Token $authToken'}),
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.statusCode != HTTP_200_OK) {
      if (response.data is Map) {
        final errorMsg = response.data[keyErr] ?? response.data[keyDetail];
        if (errorMsg != null) throw Exception(errorMsg);
      }
      throw Exception(
          'Error al retirar trabajador de la sede: ${response.statusCode}');
    }
  }
}
