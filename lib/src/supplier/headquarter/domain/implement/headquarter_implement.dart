import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/supplier/headquarter/data/datasource/headquarter_datasource.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/repository/headquarter_repository.dart';

class SupplierHeadquarterImplement implements SupplierHeadquarterRepository {
  final SupplierHeadquarterDatasource _datasource;
  final IStorage _storage;

  SupplierHeadquarterImplement({
    required SupplierHeadquarterDatasource datasource,
    required IStorage storage,
  })  : _datasource = datasource,
        _storage = storage;

  @override
  Future<Either<Failure, Unit>> deleteHeadquarter({
    required int headquarterId,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      await _datasource.deleteHeadquarter(
        authToken: token,
        headquarterId: headquarterId,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHeadquarter({
    required int headquarterId,
    required HeadquarterFormModel form,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      await _datasource.updateHeadquarter(
        authToken: token,
        headquarterId: headquarterId,
        form: form,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getWeekConfiguration({
    required int headquarterId,
  }) async {
    try {
      final token = await _storage.read(key: keyAuthToken) ?? '';
      final result = await _datasource.getWeekConfiguration(
        authToken: token,
        headquarterId: headquarterId,
      );
      return Right(result);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
