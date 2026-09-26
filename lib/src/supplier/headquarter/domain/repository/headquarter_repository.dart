import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';

abstract class SupplierHeadquarterRepository {
  Future<Either<Failure, Unit>> deleteHeadquarter({
    required int headquarterId,
  });

  Future<Either<Failure, Unit>> updateHeadquarter({
    required int headquarterId,
    required HeadquarterFormModel form,
  });

  Future<Either<Failure, Map<String, String>>> getWeekConfiguration({
    required int headquarterId,
  });
}
