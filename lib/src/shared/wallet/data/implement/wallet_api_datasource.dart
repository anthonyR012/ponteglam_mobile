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
import 'package:ponte_glam/src/shared/wallet/data/datasource/wallet_datasource.dart';
import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';

class WalletApiDatasourceImplement extends WalletApiDatasource {
  WalletApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  Options _authOptions(String authToken) =>
      Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

  @override
  Future<WalletModel> getWallet({required String authToken}) async {
    throwIfError(
        _network.status == ConnectivityResult.none, _failureManage.connectivity);

    final Response response = await _dio
        .get(
          _endPoints.walletUrl,
          options: _authOptions(authToken),
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
        response.statusCode != HTTP_200_OK, _failureManage.server("Error fetching wallet"));

    final data = response.data;
    final walletJson =
        data is Map && data.containsKey('success') ? data['success'] : data;

    return WalletModel.fromJson(walletJson);
  }
}
