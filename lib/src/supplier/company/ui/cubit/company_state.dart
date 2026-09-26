import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/company_model.dart';

abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanySuccess extends CompanyState {
  final String message;
  CompanySuccess(this.message);
}

class CompanyError extends CompanyState {
  final Failure failure;
  CompanyError(this.failure);
}

class CompanyNequiVerificationCodeSent extends CompanyState {
  final String message;
  CompanyNequiVerificationCodeSent(this.message);
}

class CompanyNequiUpdateSuccess extends CompanyState {
  final CompanyModel company;
  final String message;
  CompanyNequiUpdateSuccess(this.company, this.message);
}
