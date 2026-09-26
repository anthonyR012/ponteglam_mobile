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
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/shared/model/country_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/src/client/setting/data/datasource/setting_datasource.dart';

class SettingApiDatasourceImplement extends SettingDatasource {
  SettingApiDatasourceImplement(
      this._dio, this._network, this._endPoints, this._failureManage);

  final Dio _dio;
  final NetworkState _network;
  final EndPoints _endPoints;
  final FailureManage _failureManage;

  @override
  Future<List<CategoryModel>> getCategories() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.listCategoriesServicesUrl)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));
    return categoriesModelFromJson(jsonEncode(response.data[keySuccess]));
  }

  @override
  Future<List<TypeModel>> getTypes() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.listTypesUrl)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));

    return typeModelFromJson(jsonEncode(response.data[keySuccess]));
  }

  @override
  Future<List<TypeModel>> getTypesByCategory({required String category}) async {
    final allTypes = await getTypes();
    return allTypes.where((t) => t.categoryTypeCode == category).toList();
  }

  @override
  Future<List<CityModel>> getCities({required int countryId}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.listCitiesUrl)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));

    return cityModelFromJson(jsonEncode(response.data[keySuccess]));
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.listCountriesUrl)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));

    return countryModelFromJson(jsonEncode(response.data[keySuccess]));
  }

  @override
  Future<List<int>> getImageByPath({required String imageUrl}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(imageUrl, options: Options(responseType: ResponseType.bytes))
        .timeout(const Duration(seconds: timeOutApi));
    List<int> bytes = [];
    if (response.statusCode == HTTP_200_OK) {
      bytes = response.data;
    } else {
      if (response.data.runtimeType
          .toString()
          .contains('Map<String, dynamic>')) {
        if (response.data.containsKey(keyErr)) {
          throwClientResponse(response.statusCode, response.data[keyErr]);
        } else if (response.data.containsKey(keyDetail)) {
          throwServerResponse(response.statusCode, response.data[keyDetail]);
        }
      }
      throwIfError(response.statusCode != HTTP_200_OK,
          ServerFailure(response.data.toString()));
    }
    return bytes;
  }

  @override
  Future<List<AmenityModel>> getAmenities() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final Response response = await _dio
        .get(_endPoints.listAmenitiesUrl)
        .timeout(const Duration(seconds: timeOutApi));
    if (response.data.runtimeType.toString().contains('Map<String, dynamic>')) {
      if (response.data.containsKey(keyErr)) {
        throwClientResponse(response.statusCode, response.data[keyErr]);
      } else if (response.data.containsKey(keyDetail)) {
        throwServerResponse(response.statusCode, response.data[keyDetail]);
      }
    }
    throwIfError(response.statusCode != HTTP_200_OK,
        ServerFailure(response.data.toString()));

    return amenitiesModelFromJson(jsonEncode(response.data[keySuccess]));
  }

  @override
  Future<List<AmenityModel>> getAmenitiesByIds({required List<int> ids}) async {
    final allAmenities = await getAmenities();
    return allAmenities.where((a) => ids.contains(a.id)).toList();
  }
}
