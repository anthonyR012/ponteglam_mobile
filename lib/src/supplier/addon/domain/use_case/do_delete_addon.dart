import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class DoDeleteAddon {
  final AddonRepository repository;

  DoDeleteAddon(this.repository);

  Future<Either<Failure, bool>> call(int addonId) {
    return repository.deleteAddon(addonId);
  }
}
