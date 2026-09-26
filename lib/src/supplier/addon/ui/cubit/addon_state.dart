import 'package:equatable/equatable.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';

abstract class AddonState extends Equatable {
  const AddonState();

  @override
  List<Object?> get props => [];
}

class AddonInitial extends AddonState {}

class AddonLoading extends AddonState {}

class AddonLoaded extends AddonState {
  final List<AddonModel> linked;
  final List<AddonModel> available;

  const AddonLoaded(this.linked, this.available);

  @override
  List<Object?> get props => [linked, available];
}

class AddonSuccess extends AddonState {
  final String message;

  const AddonSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddonError extends AddonState {
  final Failure failure;

  const AddonError(this.failure);

  @override
  List<Object?> get props => [failure];
}
