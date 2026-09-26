import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/home/data/datasource/home_datasource.dart';

class HomeApiDatasourceImplement extends HomeApiDatasource {
  HomeApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<PaginatorServiceModel> getServices(
      {required String authToken,
      required Position position,
      required FilterServiceModel filter}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    Map<String, dynamic> paramateres = {
      "latitude": position.latitude,
      "longitude": position.longitude,
      "category": filter.category,
      "search": filter.query,
      "rating": filter.rating,
      "min_price": filter.minPrice,
      "max_price": filter.maxPrice,
      "mine": filter.mine
    };
    final Response response = await _dio
        .get(filter.nextUrl ?? _endPoints.listServicesUrl,
            options: options, queryParameters: paramateres)
        .timeout(const Duration(seconds: timeOutApi));
    bool hasMap =
        response.data.runtimeType.toString().contains('Map<String, dynamic>');

    throwIfError(response.data is String, _failureManage.noFound("services"));
    if (response.data.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (response.data.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    throwIfError(!hasMap || response.statusCode != HTTP_200_OK,
        _failureManage.noFound("services"));
    throwIfError(response.data["results"].length == 0,
        _failureManage.noFound("services"));
    PaginatorServiceModel paginatorServices =
        paginatorServiceModelFromJson(jsonEncode(response.data));
    return paginatorServices;
  }
}
