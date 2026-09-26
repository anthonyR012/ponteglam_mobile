import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/appointment/data/datasource/appointment_datasource.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';

class AppointmentApiDatasourceImplement extends AppointmentApiDatasource {
  AppointmentApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'Token $authToken'});

  @override
  Future<List<AppointmentModel>> listAppointments({
    required String authToken,
    String? filter,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Map<String, dynamic> queryParams = {};
    if (filter != null) queryParams['filter'] = filter;

    final Response response = await _dio
        .get(
          _endPoints.listAppointmentsUrl,
          options: _authOptions(authToken),
          queryParameters: queryParams,
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK, _failureManage.server("Error listing appointments"));

    final data = response.data;
    final List<dynamic> items = data is Map && data.containsKey('success')
        ? data['success']
        : (data is Map && data.containsKey('results')
            ? data['results']
            : (data is List ? data : []));

    return items.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  @override
  Future<List<AppointmentModel>> listSupplierAppointments({
    required String authToken,
    required int serviceId,
    String status = 'upcoming',
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Map<String, dynamic> queryParams = {
      'service_id': serviceId,
      'status': status,
    };

    final Response response = await _dio
        .get(
          _endPoints.supplierAppointmentsUrl,
          options: _authOptions(authToken),
          queryParameters: queryParams,
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK, _failureManage.server("Error listing supplier appointments"));

    final data = response.data;
    final List<dynamic> items =
        data is Map && data.containsKey('success') ? data['success'] : (data is List ? data : []);

    return items.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  @override
  Future<AppointmentModel> getAppointmentDetail({
    required String authToken,
    required int appointmentId,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final String url = '${_endPoints.appointmentDetailUrl}$appointmentId/';
    final Response response = await _dio
        .get(url, options: _authOptions(authToken))
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK, _failureManage.server("Error fetching appointment"));

    final data = response.data;
    final appointmentJson =
        data is Map && data.containsKey('success') ? data['success'] : data;

    return AppointmentModel.fromJson(appointmentJson);
  }

  @override
  Future<void> cancelAppointment({
    required String authToken,
    required int appointmentId,
    String? reason,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final String url = '${_endPoints.cancelAppointmentUrl}$appointmentId/';
    final Map<String, dynamic> body = {};
    if (reason != null && reason.isNotEmpty) body['cancellation_reason'] = reason;

    final Response response = await _dio
        .patch(url, options: _authOptions(authToken), data: body)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK, _failureManage.server("Error cancelling appointment"));
  }

  @override
  Future<void> rescheduleAppointment({
    required String authToken,
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
    int? workerId,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final String url = '${_endPoints.rescheduleAppointmentUrl}$appointmentId/';
    final Map<String, dynamic> body = {
      'new_start_time': newStartTime,
      'new_end_time': newEndTime,
    };
    if (workerId != null) body['worker_id'] = workerId;

    final Response response = await _dio
        .patch(url, options: _authOptions(authToken), data: body)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(response.statusCode != HTTP_200_OK,
        _failureManage.server("Error rescheduling appointment"));
  }

  @override
  Future<AppointmentModel> confirmCashAppointment({
    required String authToken,
    required int appointmentId,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final String url =
        '${_endPoints.confirmCashAppointmentUrl}$appointmentId/';

    final Response response = await _dio
        .patch(url, options: _authOptions(authToken), data: {})
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey('error') &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data['error']);
      }
    }

    throwIfError(response.statusCode != HTTP_200_OK,
        _failureManage.server("Error confirming cash appointment"));

    final data = response.data;
    final appointmentJson =
        data is Map && data.containsKey('success') ? data['success'] : data;

    return AppointmentModel.fromJson(appointmentJson);
  }

  @override
  Future<void> rateAppointment({
    required String authToken,
    required int appointmentId,
    required int serviceId,
    required int rating,
    required String comment,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final String url = _endPoints.createRatingHeadquarterServiceUrl;
    final Map<String, dynamic> body = {
      'appointment_id': appointmentId,
      'service_id': serviceId,
      'rating': rating,
      'comment': comment,
    };

    final Response response = await _dio
        .post(url, options: _authOptions(authToken), data: body)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey('error') &&
          response.statusCode != HTTP_200_OK &&
          response.statusCode != HTTP_201_CREATED) {
        throwServerResponse(response.statusCode, response.data['error']);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK && response.statusCode != HTTP_201_CREATED,
        _failureManage.server("Error rating appointment"));
  }
}
