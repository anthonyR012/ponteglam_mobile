import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class DoUpdateAddon {
  final AddonRepository repository;

  DoUpdateAddon(this.repository);

  Future<Either<Failure, AddonModel>> call({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) {
    return repository.updateAddon(
      addonId: addonId,
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );
  }
}
