import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/confirmation_account/data/datasource/confirmation_account_datasource.dart';

class ConfirmationAccountApiDatasource extends ConfirmationAccountDatasource {
  ConfirmationAccountApiDatasource(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<String> verifyEmail(
      {required String code, required String authToken}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    final Response response = await _dio
        .post(_endPoints.verifyEmailUrl, data: {"code": code}, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    Map<String, dynamic> result = {};
    try {
      result = json.decode(response.data);
    } catch (e) {
      result = response.data;
    }
    if (result.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (result.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    return response.data[keySuccess];
  }

  @override
  Future<String> resendEmail({required String authToken}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    final Response response = await _dio
        .post(_endPoints.forwardVerifimationEmailUrl, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    Map<String, dynamic> result = {};
    try {
      result = json.decode(response.data);
    } catch (e) {
      result = response.data;
    }
    if (result.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (result.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    return response.data[keySuccess];
  }
}
