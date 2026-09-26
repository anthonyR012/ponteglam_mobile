import 'dart:convert';

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
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/sign_up/data/datasource/sign_up_datasource.dart';

class SignUpApiDatasourceImplement extends SignUpDatasource {
  SignUpApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final NetworkState _network;
  final Dio _dio;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<UserModel> signUp({required UserModel user}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Map<String, dynamic> userSend =
        jsonDecode(userModelSingUpToJson(user));
    userSend["accepted_terms"] = true;
    if (user.picture != null) {
      final multiPartForm = await MultipartFile.fromFile(user.picture!);
      userSend["picture"] = multiPartForm;
    }
    final Response response = await _dio
        .post(_endPoints.createUserAlternateUrl,
            data: FormData.fromMap(userSend))
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        ServerFailure(response.data.toString()));
    return userModelFromJson(jsonEncode(response.data["user"]));
  }
}
