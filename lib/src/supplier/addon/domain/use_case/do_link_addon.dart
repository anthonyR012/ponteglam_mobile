import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class DoLinkAddon {
  final AddonRepository repository;

  DoLinkAddon(this.repository);

  Future<Either<Failure, bool>> call({
    required int addonId,
    required int serviceId,
  }) {
    return repository.linkAddon(addonId: addonId, serviceId: serviceId);
  }
}
