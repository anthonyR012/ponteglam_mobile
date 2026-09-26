import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_delete_company.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_update_company.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_request_nequi_update.dart';
import 'package:ponte_glam/src/supplier/company/domain/use_case/do_update_nequi_number.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final DoUpdateCompany _doUpdateCompany;
  final DoDeleteCompany _doDeleteCompany;
  final DoRequestNequiUpdate _doRequestNequiUpdate;
  final DoUpdateNequiNumber _doUpdateNequiNumber;

  CompanyCubit({
    required DoUpdateCompany doUpdateCompany,
    required DoDeleteCompany doDeleteCompany,
    required DoRequestNequiUpdate doRequestNequiUpdate,
    required DoUpdateNequiNumber doUpdateNequiNumber,
  })  : _doUpdateCompany = doUpdateCompany,
        _doDeleteCompany = doDeleteCompany,
        _doRequestNequiUpdate = doRequestNequiUpdate,
        _doUpdateNequiNumber = doUpdateNequiNumber,
        super(CompanyInitial());

  Future<void> updateCompany({
    required int companyId,
    required String name,
    required String description,
    File? profileImage,
  }) async {
    if (isClosed) return;
    emit(CompanyLoading());
    final result = await _doUpdateCompany(
      companyId: companyId,
      name: name,
      description: description,
      profileImage: profileImage,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyError(failure)),
      (_) => emit(CompanySuccess('Empresa actualizada correctamente.')),
    );
  }

  Future<void> deleteCompany({required int companyId}) async {
    if (isClosed) return;
    emit(CompanyLoading());
    final result = await _doDeleteCompany(companyId: companyId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyError(failure)),
      (_) => emit(CompanySuccess('Empresa eliminada correctamente.')),
    );
  }

  Future<void> requestNequiUpdate({required int companyId}) async {
    if (isClosed) return;
    emit(CompanyLoading());
    final result = await _doRequestNequiUpdate(companyId: companyId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyError(failure)),
      (_) => emit(CompanyNequiVerificationCodeSent(
          'Código de verificación enviado a tu correo.')),
    );
  }

  Future<void> updateNequiNumber({
    required int companyId,
    required String nequiNumber,
    required String verificationCode,
  }) async {
    if (isClosed) return;
    emit(CompanyLoading());
    final result = await _doUpdateNequiNumber(
      companyId: companyId,
      nequiNumber: nequiNumber,
      verificationCode: verificationCode,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyError(failure)),
      (company) => emit(CompanyNequiUpdateSuccess(
          company, 'Número de Nequi actualizado correctamente.')),
    );
  }
}
