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
import 'package:ponte_glam/src/client/rate/data/datasource/rating_datasource.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';

class RatingApiDatasourceImplement extends RatingApiDatasource {
  RatingApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);

  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

  @override
  Future<List<RatingModel>> listRatings({
    required String authToken,
    required int serviceId,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Response response = await _dio
        .get(
          _endPoints.listRatingsHeadquarterServiceUrl,
          options: _authOptions(authToken),
          queryParameters: {'service_id': serviceId},
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
        response.statusCode != HTTP_200_OK,
        _failureManage.server('Error listing ratings'));

    final data = response.data;
    final List<dynamic> items =
        data is Map && data.containsKey(keySuccess) ? data[keySuccess] : [];

    return items.map((e) => RatingModel.fromJson(e)).toList();
  }

  @override
  Future<RatingModel> createRating({
    required String authToken,
    required int serviceId,
    required int appointmentId,
    required int rating,
    required String comment,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Response response = await _dio
        .post(
          _endPoints.createRatingHeadquarterServiceUrl,
          options: _authOptions(authToken),
          data: {
            'service_id': serviceId,
            'appointment_id': appointmentId,
            'rating': rating,
            'comment': comment,
          },
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey('error') &&
          response.statusCode != HTTP_201_CREATED) {
        throwServerResponse(response.statusCode, response.data['error']);
      }
    }

    throwIfError(
        response.statusCode != HTTP_201_CREATED,
        _failureManage.server('Error creating rating'));

    final data = response.data;
    final ratingJson =
        data is Map && data.containsKey(keySuccess) ? data[keySuccess] : data;

    return RatingModel.fromJson(ratingJson);
  }

  @override
  Future<RatingModel> replyRating({
    required String authToken,
    required int ratingId,
    required String reply,
  }) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Response response = await _dio
        .post(
          _endPoints.replyRatingUrl,
          options: _authOptions(authToken),
          data: {
            'rating_id': ratingId,
            'reply': reply,
          },
        )
        .timeout(const Duration(seconds: timeOutApi));

    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey('error') &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data['error']);
      }
    }

    throwIfError(
        response.statusCode != HTTP_200_OK,
        _failureManage.server('Error replying to rating'));

    final data = response.data;
    final ratingJson =
        data is Map && data.containsKey(keySuccess) ? data[keySuccess] : data;

    return RatingModel.fromJson(ratingJson);
  }
}
