import 'package:ponte_glam/core/errors/failure.dart';

abstract class SupplierHeadquarterState {}

class HeadquarterInitial extends SupplierHeadquarterState {}

class HeadquarterLoading extends SupplierHeadquarterState {}

class HeadquarterDeleted extends SupplierHeadquarterState {}

class HeadquarterError extends SupplierHeadquarterState {
  final Failure failure;
  HeadquarterError(this.failure);
}
