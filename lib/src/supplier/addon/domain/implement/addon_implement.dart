import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/src/supplier/addon/data/datasource/addon_datasource.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class AddonImplement implements AddonRepository {
  final AddonDataSource dataSource;

  AddonImplement(this.dataSource);

  @override
  Future<Either<Failure, Map<String, List<AddonModel>>>> getServiceAddons(
      int serviceId) async {
    final result = await dataSource.getServiceAddons(serviceId);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          final linkedData = data['linked'] as List<dynamic>? ?? [];
          final availableData = data['available'] as List<dynamic>? ?? [];

          final linked = linkedData
              .map((e) => AddonModel.fromJson(e as Map<String, dynamic>))
              .toList();
          final available = availableData
              .map((e) => AddonModel.fromJson(e as Map<String, dynamic>))
              .toList();

          return Right({
            'linked': linked,
            'available': available,
          });
        } catch (e) {
          return Left(ServerFailure("Error procesando datos"));
        }
      },
    );
  }

  @override
  Future<Either<Failure, AddonModel>> createAddon({
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) async {
    final result = await dataSource.createAddon(
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          return Right(AddonModel.fromJson(data));
        } catch (e) {
          return Left(ServerFailure("Error procesando adicional"));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> linkAddon({
    required int addonId,
    required int serviceId,
  }) {
    return dataSource.linkAddon(addonId: addonId, serviceId: serviceId);
  }

  @override
  Future<Either<Failure, bool>> unlinkAddon({
    required int addonId,
    required int serviceId,
  }) {
    return dataSource.unlinkAddon(addonId: addonId, serviceId: serviceId);
  }

  @override
  Future<Either<Failure, AddonModel>> updateAddon({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) async {
    final result = await dataSource.updateAddon(
      addonId: addonId,
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          return Right(AddonModel.fromJson(data));
        } catch (e) {
          return Left(ServerFailure("Error procesando adicional"));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAddon(int addonId) {
    return dataSource.deleteAddon(addonId);
  }
}
