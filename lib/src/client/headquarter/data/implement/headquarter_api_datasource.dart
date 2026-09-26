import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/headquarter/data/datasource/headquarter_datasource.dart';

class HeadquarterApiDatasourceImplement extends HeadquarterDatasource {
  HeadquarterApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<String> like(
      {required String authToken, required int headquarterCompanyId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    Map<String, dynamic>? paramateres = {
      "headquarter_id": headquarterCompanyId
    };
    final Response response = await _dio
        .post(_endPoints.likeHeadquarterUrl,
            options: options, data: paramateres)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    } else {
      throwIfError(response.statusCode != HTTP_200_OK,
          ServerFailure(response.data.toString()));
    }
    return response.data[keySuccess];
  }

  @override
  Future<String> dislike(
      {required String authToken, required int headquarterCompanyId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    Map<String, dynamic>? paramateres = {
      "headquarter_id": headquarterCompanyId
    };
    final Response response = await _dio
        .post(_endPoints.dislikeHeadquarterUrl,
            options: options, data: paramateres)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    } else {
      throwIfError(response.statusCode != HTTP_200_OK,
          ServerFailure(response.data.toString()));
    }
    return response.data[keySuccess];
  }
}
