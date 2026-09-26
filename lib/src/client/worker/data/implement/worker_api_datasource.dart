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
import 'package:ponte_glam/shared/model/worker_model.dart';
import 'package:ponte_glam/src/client/worker/data/datasource/worker_datasource.dart';

class WorkerApiDatasourceImplement extends WorkerApiDatasource {
  WorkerApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<List<WorkerModel>> getWorkers(
      {required String authToken, int? headQuarterId, int? serviceId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);

    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    Map<String, dynamic> parameters = {};
    if (headQuarterId != null) {
      parameters['head_quarter_id'] = headQuarterId;
    }
    if (serviceId != null) {
      parameters['service_id'] = serviceId;
    }

    final Response response = await _dio
        .get(_endPoints.listWorkersUrl,
            options: options, queryParameters: parameters)
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK, _failureManage.noFound("workers"));

    if (response.data is List) {
      List<dynamic> listJson = response.data;
      return listJson.map((json) => WorkerModel.fromJson(json)).toList();
    } else if (response.data is Map && response.data.containsKey('success')) {
      List<dynamic> listJson = response.data['success'];
      return listJson.map((json) => WorkerModel.fromJson(json)).toList();
    } else if (response.data is Map && response.data.containsKey('results')) {
      List<dynamic> listJson = response.data['results'];
      return listJson.map((json) => WorkerModel.fromJson(json)).toList();
    }

    return [];
  }
}
