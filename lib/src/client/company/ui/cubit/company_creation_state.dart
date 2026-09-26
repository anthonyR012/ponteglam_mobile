import 'package:equatable/equatable.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';

sealed class CompanyCreationState extends Equatable {
  final CompanyFormModel form;
  const CompanyCreationState(this.form);

  @override
  List<Object?> get props => [form];
}

final class CompanyCreationInitial extends CompanyCreationState {
  const CompanyCreationInitial(super.form);
}

class CompanyCreationLoading extends CompanyCreationState {
  const CompanyCreationLoading(super.form);
}

class CompanyCreationError extends CompanyCreationState {
  final String message;
  const CompanyCreationError(super.form, this.message);

  @override
  List<Object?> get props => [form, message];
}

class CompanyCreationSuccess extends CompanyCreationState {
  const CompanyCreationSuccess(super.form);
}
