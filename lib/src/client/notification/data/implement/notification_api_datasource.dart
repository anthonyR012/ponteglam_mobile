import 'dart:convert';
import 'dart:io';

import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';

class NotificationApiDatasourceImplement implements NotificationApiDatasource {
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  NotificationApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

  @override
  Future<NotificationListModel> getNotifications(
      {required String authToken, String? nextUrl, int? companyId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(nextUrl ?? _endPoints.listNotificationsUrl,
            queryParameters: companyId != null ? {'company_id': companyId} : null,
            options: _authOptions(authToken))
        .timeout(const Duration(seconds: timeOutApi));
    final responseData = response.data;
    Map<String, dynamic>? parsedData;

    if (responseData is String) {
      try {
        parsedData = jsonDecode(responseData) as Map<String, dynamic>?;
      } catch (_) {
        parsedData = null;
      }
    } else if (responseData is Map<String, dynamic>) {
      parsedData = responseData;
    } else {
      parsedData = null;
    }

    if (parsedData != null) {
      if (parsedData.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, parsedData[keyErr]);
      } else if (parsedData.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, parsedData[keyDetail]);
      }
    }
    throwIfError(responseData is! Map || response.statusCode != HTTP_200_OK,
        _failureManage.noFound("notifications"));
    throwIfError(
        responseData["results"] == null || responseData["results"].isEmpty,
        _failureManage.noFound("notifications"));
    return notificationListModelFromJson(jsonEncode(responseData));
  }

  @override
  Future<void> registerDevice({
    required String authToken,
    required String registrationId,
    required String deviceType,
  }) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    await _dio
        .post(
          _endPoints.registerDeviceUrl,
          data: {
            'registration_id': registrationId,
            'device_type': deviceType,
          },
          options: _authOptions(authToken),
        )
        .timeout(const Duration(seconds: timeOutApi));
    // fire-and-forget: no error propagation
  }

  @override
  Future<int> getUnreadCount({required String authToken, int? companyId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.unreadNotificationsCountUrl,
            queryParameters: companyId != null ? {'company_id': companyId} : null,
            options: _authOptions(authToken))
        .timeout(const Duration(seconds: timeOutApi));
    final data = response.data;
    if (data is Map && data.containsKey('count')) {
      return (data['count'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }
}
