import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class DoCreateAddon {
  final AddonRepository repository;

  DoCreateAddon(this.repository);

  Future<Either<Failure, AddonModel>> call({
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
  }) {
    return repository.createAddon(
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );
  }
}
