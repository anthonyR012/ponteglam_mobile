import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/book/data/datasource/booking_datasource.dart';
import 'package:ponte_glam/src/client/book/data/model/create_appointment_response.dart';

class BookingApiDatasourceImplement extends BookingApiDatasource {
  BookingApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

  @override
  Future<CreateAppointmentResponse> createAppointment({
    required String authToken,
    required int serviceId,
    required int workerId,
    required String startTime,
    required String endTime,
    String paymentMethod = 'card',
    bool isHomeService = false,
    int? homeAddressId,
    List<int>? addonIds,
  }) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);

    final Map<String, dynamic> body = {
      'service_id': serviceId,
      'worker_id': workerId,
      'start_time': startTime,
      'end_time': endTime,
      'payment_method': paymentMethod,
      'is_home_service': isHomeService,
      if (homeAddressId != null) 'home_address_id': homeAddressId,
      if (addonIds != null && addonIds.isNotEmpty) 'addon_ids': addonIds,
    };

    final Response response = await _dio
        .post(_endPoints.createAppointmentUrl,
            options: _authOptions(authToken), data: body)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey('error')) {
        throwClientResponse(response.statusCode, response.data['error']);
      } else if (response.data.containsKey('detail') &&
          response.statusCode != HTTP_201_CREATED) {
        throwServerResponse(response.statusCode, response.data['detail']);
      }
    }

    throwIfError(response.statusCode != HTTP_201_CREATED,
        _failureManage.server('Error creating appointment'));

    return CreateAppointmentResponse.fromJson(response.data);
  }

  @override
  Future<List<AvailableDateModel>> getAvailableDates({
    required String authToken,
    required int serviceId,
    int? workerId,
    int? headQuarterId,
    int days = 15,
  }) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);

    final Map<String, dynamic> params = {
      'service_id': serviceId,
      'days': days,
    };
    if (workerId != null) params['worker_id'] = workerId;
    if (headQuarterId != null) params['head_quarter_id'] = headQuarterId;

    final Response response = await _dio
        .get(_endPoints.listAvailableWorkersUrl,
            options: _authOptions(authToken), queryParameters: params)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey('error')) {
        throwClientResponse(response.statusCode, response.data['error']);
      } else if (response.data.containsKey('detail') &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data['detail']);
      }
    }

    throwIfError(response.statusCode != HTTP_200_OK,
        _failureManage.server('Error fetching available dates'));

    if (response.data is Map && response.data.containsKey('success')) {
      final list = response.data['success'] as List<dynamic>;
      return list
          .map((e) => AvailableDateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
