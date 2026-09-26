import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';

abstract class AddonRepository {
  Future<Either<Failure, Map<String, List<AddonModel>>>> getServiceAddons(
      int serviceId);

  Future<Either<Failure, AddonModel>> createAddon({
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  });

  Future<Either<Failure, bool>> linkAddon({
    required int addonId,
    required int serviceId,
  });

  Future<Either<Failure, bool>> unlinkAddon({
    required int addonId,
    required int serviceId,
  });

  Future<Either<Failure, AddonModel>> updateAddon({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  });

  Future<Either<Failure, bool>> deleteAddon(int addonId);
}
