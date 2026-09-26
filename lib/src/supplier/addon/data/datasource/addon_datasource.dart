import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';

abstract class AddonDataSource {
  Future<Either<Failure, Map<String, dynamic>>> getServiceAddons(int serviceId);
  Future<Either<Failure, Map<String, dynamic>>> createAddon({
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
  Future<Either<Failure, Map<String, dynamic>>> updateAddon({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  });
  Future<Either<Failure, bool>> deleteAddon(int addonId);
}
