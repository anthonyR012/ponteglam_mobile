import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/src/supplier/addon/domain/repository/addon_repository.dart';

class DoGetServiceAddons {
  final AddonRepository repository;

  DoGetServiceAddons(this.repository);

  Future<Either<Failure, Map<String, List<AddonModel>>>> call(int serviceId) {
    return repository.getServiceAddons(serviceId);
  }
}
