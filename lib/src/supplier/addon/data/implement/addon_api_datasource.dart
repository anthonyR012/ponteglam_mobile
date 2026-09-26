import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/supplier/addon/data/datasource/addon_datasource.dart';

class AddonApiDataSource implements AddonDataSource {
  final Dio dio;
  final EndPoints endPoints;
  final IStorage storage;

  AddonApiDataSource(this.dio, this.endPoints, this.storage);

  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: keyAuthToken) ?? '';
    return {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getServiceAddons(
      int serviceId) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.get(
        endPoints.listServiceAddonsUrl,
        queryParameters: {'service_id': serviceId},
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Right(response.data['success']);
      }
      return Left(ServerFailure("Error al cargar adicionales"));
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['error'] ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createAddon({
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) async {
    try {
      final headers = await _getHeaders();
      final data = {
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
        'price': price,
        'duration_minutes': durationMinutes,
      };

      final response = await dio.post(
        endPoints.createServiceAddonUrl,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        return Right(response.data['success']);
      }
      return Left(ServerFailure("Error al crear adicional"));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['error']?.toString() ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> linkAddon({
    required int addonId,
    required int serviceId,
  }) async {
    try {
      final headers = await _getHeaders();
      final data = {
        'addon_id': addonId,
        'service_id': serviceId,
      };

      final response = await dio.post(
        endPoints.linkAddonToServiceUrl,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left(ServerFailure("Error al vincular adicional"));
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['error'] ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkAddon({
    required int addonId,
    required int serviceId,
  }) async {
    try {
      final headers = await _getHeaders();
      final data = {
        'addon_id': addonId,
        'service_id': serviceId,
      };

      final response = await dio.post(
        endPoints.unlinkAddonFromServiceUrl,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left(ServerFailure("Error al desvincular adicional"));
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['error'] ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateAddon({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) async {
    try {
      final headers = await _getHeaders();
      final data = {
        'name': name,
        'description': description ?? '',
        'price': price,
        'duration_minutes': durationMinutes,
      };

      final response = await dio.patch(
        endPoints.updateServiceAddonUrl(addonId),
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Right(response.data['success']);
      }
      return Left(ServerFailure("Error al actualizar adicional"));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['error']?.toString() ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddon(int addonId) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.delete(
        endPoints.deleteServiceAddonUrl(addonId),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left(ServerFailure("Error al eliminar adicional"));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['error']?.toString() ?? "Error de conexión"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
