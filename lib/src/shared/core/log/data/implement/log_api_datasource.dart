import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/shared/core/log/data/datasource/log_datasource.dart';
import 'package:ponte_glam/src/shared/core/log/domain/model/mobile_log_model.dart';

class LogApiDatasourceImplement extends LogDatasource {
  LogApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._storage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final IStorage _storage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

  @override
  Future<void> createMobileLogs(List<MobileLogModel> logs) async {
    // Avoid recursion: don't log if we are already logging
    // Also skip if no network
    if (_network.status == ConnectivityResult.none) return;

    final authToken = await _storage.read(key: keyAuthToken);
    if (authToken == null) return;

    try {
      final Response response = await _dio
          .post(
            _endPoints.createMobileAppLogUrl,
            data: logs.map((e) => e.toJson()).toList(),
            options: _authOptions(authToken),
          )
          .timeout(const Duration(seconds: timeOutApi));

      if (response.statusCode != HTTP_201_CREATED) {
        debugPrint("Error sending logs: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception sending logs: $e");
    }
  }
}
