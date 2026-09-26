import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/sign_up/data/datasource/terms_datasource.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TermsApiDatasourceImplement extends TermsDatasource {
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  TermsApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);

  @override
  Future<void> acceptTerms({required int userId, required String token}) async {
    if (_network.status == ConnectivityResult.none) return;
    final Options options = Options(
      headers: {HttpHeaders.authorizationHeader: 'token $token'},
    );
    await _dio
        .post(
          _endPoints.termsAndConditionsUrl,
          data: {'user': userId, 'accepted': true},
          options: options,
        )
        .timeout(const Duration(seconds: timeOutApi));
  }

  @override
  Future<String> getLegalContent(String typeCode) async {
    if (_network.status == ConnectivityResult.none) {
      throw Failure('No internet connection');
    }

    try {
      final response = await _dio.get(
        _endPoints.listLegalContentUrl,
        queryParameters: {'type': typeCode},
      ).timeout(const Duration(seconds: timeOutApi));

      final data = response.data['success'] as List;
      if (data.isNotEmpty) {
        return data.first['content'] as String;
      }
      return '';
    } on DioException catch (e) {
      throw _failureManage.server(e.message ?? '');
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
