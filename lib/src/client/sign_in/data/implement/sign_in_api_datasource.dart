import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/sign_in/data/datasource/sign_in_datasource.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class SignInApiDatasourceImplement extends SingInApiDatasource {
  SignInApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<UserModel> signIn({String? username, String? password}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio.post(_endPoints.authTokenUrl, data: {
      "username": username,
      "password": password
    }).timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));
    UserModel user = userModelFromJson(jsonEncode(response.data["user"]));
    if (response.data.containsKey('token')) {
      user = user.copyWith(token: response.data['token']);
    }
    return user;
  }

  @override
  Future<UserModel> saveUser({required UserModel user}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Map<String, dynamic> oauthPayload = jsonDecode(userModelToJson(user));
    oauthPayload["accepted_terms"] = user.hasAcceptedTerms ?? false;
    final Response response = await _dio
        .post(_endPoints.creatUserOauthUrl, data: oauthPayload)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    if (response.data.containsKey('accepted_terms') &&
        response.statusCode != HTTP_200_OK) {
      throwClientResponse(
          response.statusCode, response.data['accepted_terms'][0]);
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        ServerFailure(response.data.toString()));
    UserModel userResult = userModelFromJson(jsonEncode(response.data["user"]));
    if (response.data.containsKey('token')) {
      userResult = userResult.copyWith(token: response.data['token']);
    }
    return userResult;
  }

  @override
  Future<void> registerFcmToken({required String authToken}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;
    final Response response = await _dio
        .post(
          _endPoints.registerDeviceUrl,
          data: {"registration_id": fcmToken},
          options: Options(
            headers: {"Authorization": "token $authToken"},
          ),
        )
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data != null &&
        response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        ServerFailure(
            response.data?.toString() ?? 'Register FCM token failed'));
  }

  @override
  Future<void> deleteFcmToken({
    required String authToken,
    required String fcmToken,
  }) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .delete(
          _endPoints.registerDeviceUrl,
          data: {"registration_id": fcmToken},
          options: Options(
            headers: {"Authorization": "token $authToken"},
          ),
        )
        .timeout(const Duration(seconds: timeOutApi));
    if (response.statusCode == HTTP_200_OK ||
        response.statusCode == HTTP_204_NO_CONTENT) {
      return;
    }
    if (response.data != null &&
        response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(true,
        ServerFailure(response.data?.toString() ?? 'Delete FCM token failed'));
  }
}
