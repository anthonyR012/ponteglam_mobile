import 'dart:convert';
import 'dart:io';

import 'package:ponte_glam/config/constant/http_response_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/throw_response_client.dart';
import 'package:ponte_glam/core/errors/throw_response_server.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/profile/data/datasource/profile_datasource.dart';

class ProfileApiDatasourceImplement implements ProfileApiDatasource {
  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  ProfileApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);

  @override
  Future<AddressModel> createUserAddress(
      {required String authToken, required AddressModel address}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    final Response response = await _dio
        .post(_endPoints.createUserAddressUrl,
            data: address.toJson(), options: options)
        .timeout(const Duration(seconds: timeOutApi));
    bool hasMap =
        response.data.runtimeType.toString().contains('Map<String, dynamic>');
    throwIfError(!hasMap, _failureManage.wentWrong);
    if (response.data.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (response.data.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
    throwIfError(response.data["address"] == null, _failureManage.wentWrong);
    AddressModel addressCreated =
        addressModelFromJson(jsonEncode(response.data["address"]));
    return addressCreated;
  }

  @override
  Future<List<AddressModel>> getUserAddresses(
      {required String authToken}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    final Response response = await _dio
        .get(_endPoints.listAddressesUserUrl, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    bool hasMap =
        response.data.runtimeType.toString().contains('Map<String, dynamic>');
    throwIfError(!hasMap, _failureManage.wentWrong);
    if (response.data.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (response.data.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        _failureManage.noFound("addresses"));
    List<AddressModel> addresses =
        addressesModelFromJson(jsonEncode(response.data[keySuccess]));
    return addresses;
  }

  @override
  Future<String> updateUserAddress(
      {required String? authToken, required AddressModel address}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    final body = address.toMapUpdate();
    final Response response = await _dio
        .post(_endPoints.updateUserAddressUrl, data: body, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    bool hasMap =
        response.data.runtimeType.toString().contains('Map<String, dynamic>');
    throwIfError(!hasMap, _failureManage.wentWrong);
    if (response.data.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (response.data.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
    return response.data[keySuccess];
  }

  @override
  Future<void> deleteUserAddress(
      {required String authToken, required int addressId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});
    final Response response = await _dio
        .delete(_endPoints.deleteUserAddressUrl(addressId), options: options)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail) &&
          response.statusCode != HTTP_200_OK) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK, _failureManage.wentWrong);
  }

  @override
  Future<UserModel> updateUserInformation(
      {required String authToken,
      required Map<String, dynamic> data,
      bool isMultipart = false}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    dynamic body;
    if (isMultipart) {
      final Map<String, dynamic> formDataMap = {};
      for (var entry in data.entries) {
        if (entry.key == 'picture' && entry.value is String) {
          formDataMap[entry.key] = await MultipartFile.fromFile(entry.value);
        } else {
          formDataMap[entry.key] = entry.value;
        }
      }
      body = FormData.fromMap(formDataMap);
    } else {
      body = data;
    }

    final Response response = await _dio
        .post(_endPoints.updateUserInformationUrl, data: body, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    bool hasMap =
        response.data.runtimeType.toString().contains('Map<String, dynamic>');
    throwIfError(!hasMap, _failureManage.wentWrong);
    if (response.data.containsKey(keyErr)) {
      throwClientResponse(response.statusCode, response.data[keyErr]);
    } else if (response.data.containsKey(keyDetail)) {
      throwServerResponse(response.statusCode, response.data[keyDetail]);
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<void> requestCreatePassword({required String authToken}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    final Response response = await _dio
        .post(_endPoints.requestCreatePasswordUrl, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data is Map) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      } else if (response.statusCode != HTTP_200_OK &&
          response.statusCode != HTTP_201_CREATED) {
        final errorMap = response.data as Map<String, dynamic>;
        if (errorMap.isNotEmpty) {
          final firstKey = errorMap.keys.first;
          final firstVal = errorMap[firstKey];
          String errorMessage;
          if (firstVal is List && firstVal.isNotEmpty) {
            errorMessage = firstVal.first.toString();
          } else {
            errorMessage = firstVal.toString();
          }
          throwClientResponse(response.statusCode, errorMessage);
        }
      }
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
  }

  @override
  Future<void> confirmCreatePassword(
      {required String authToken,
      required String code,
      required String newPassword}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    final Response response = await _dio
        .post(_endPoints.confirmCreatePasswordUrl,
            data: {'code': code, 'new_password': newPassword}, options: options)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data is Map) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      } else if (response.statusCode != HTTP_200_OK &&
          response.statusCode != HTTP_201_CREATED) {
        final errorMap = response.data as Map<String, dynamic>;
        if (errorMap.isNotEmpty) {
          final firstKey = errorMap.keys.first;
          final firstVal = errorMap[firstKey];
          String errorMessage;
          if (firstVal is List && firstVal.isNotEmpty) {
            errorMessage = firstVal.first.toString();
          } else {
            errorMessage = firstVal.toString();
          }
          throwClientResponse(response.statusCode, errorMessage);
        }
      }
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
  }

  @override
  Future<void> updateUserPassword(
      {required String authToken,
      required String oldPassword,
      required String newPassword}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Options options =
        Options(headers: {HttpHeaders.authorizationHeader: 'token $authToken'});

    final Response response = await _dio
        .post(_endPoints.updateUserPasswordUrl,
            data: {'old_password': oldPassword, 'new_password': newPassword},
            options: options)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data is Map) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      } else if (response.statusCode != HTTP_200_OK &&
          response.statusCode != HTTP_201_CREATED) {
        // Handle field specific errors from DRF
        final errorMap = response.data as Map<String, dynamic>;
        if (errorMap.isNotEmpty) {
          final firstKey = errorMap.keys.first;
          final firstVal = errorMap[firstKey];
          String errorMessage;
          if (firstVal is List && firstVal.isNotEmpty) {
            errorMessage = firstVal.first.toString();
          } else {
            errorMessage = firstVal.toString();
          }
          throwClientResponse(response.statusCode, errorMessage);
        }
      }
    }
    throwIfError(
        response.statusCode != HTTP_200_OK &&
            response.statusCode != HTTP_201_CREATED,
        _failureManage.wentWrong);
  }
}
