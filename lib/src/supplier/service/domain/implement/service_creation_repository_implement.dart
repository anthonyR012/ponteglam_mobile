import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/supplier/service/data/datasource/service_creation_datasource.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';
import 'package:ponte_glam/src/supplier/service/domain/repository/service_creation_repository.dart';

class ServiceCreationRepositoryImplement extends ServiceCreationRepository {
  ServiceCreationRepositoryImplement({
    required this.datasource,
    required this.storage,
  });

  final ServiceCreationDatasource datasource;
  final IStorage storage;

  @override
  Future<Either<Failure, int>> createService({
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? '';
      final id = await datasource.createService(
        authToken: token,
        form: form,
        headquarterId: headquarterId,
      );
      return Right(id);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateService({
    required int serviceId,
    required ServiceCreationFormModel form,
    required int headquarterId,
  }) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? '';
      final id = await datasource.updateService(
        authToken: token,
        serviceId: serviceId,
        form: form,
        headquarterId: headquarterId,
      );
      return Right(id);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteService({
    required int serviceId,
  }) async {
    try {
      final token = await storage.read(key: keyAuthToken) ?? '';
      await datasource.deleteService(
        authToken: token,
        serviceId: serviceId,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
