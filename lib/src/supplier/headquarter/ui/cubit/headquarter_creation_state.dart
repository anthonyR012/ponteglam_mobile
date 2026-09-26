import 'package:equatable/equatable.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';

abstract class HeadquarterCreationState extends Equatable {
  final HeadquarterFormModel form;

  const HeadquarterCreationState(this.form);

  @override
  List<Object> get props => [form];
}

class HeadquarterCreationInitial extends HeadquarterCreationState {
  const HeadquarterCreationInitial(super.form);
}

class HeadquarterCreationLoading extends HeadquarterCreationState {
  const HeadquarterCreationLoading(super.form);
}

class HeadquarterCreationSuccess extends HeadquarterCreationState {
  const HeadquarterCreationSuccess(super.form);
}

class HeadquarterCreationError extends HeadquarterCreationState {
  final String message;

  const HeadquarterCreationError(super.form, this.message);

  @override
  List<Object> get props => [form, message];
}
