import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/domain/use_case/do_create_company_use_cases.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_state.dart';

class CompanyCreationCubit extends Cubit<CompanyCreationState> {
  final SharedPreferences sharedPreferences;
  final DoCreateCompany doCreateCompany;
  final DoCreateHeadquarter doCreateHeadquarter;
  final DoCreateTimeConfig doCreateTimeConfig;

  static const String _draftKey = keyCompanyDraft;

  CompanyCreationCubit({
    required this.sharedPreferences,
    required this.doCreateCompany,
    required this.doCreateHeadquarter,
    required this.doCreateTimeConfig,
  }) : super(const CompanyCreationInitial(CompanyFormModel())) {
    _loadDraft();
  }

  void _loadDraft() {
    final draftJson = sharedPreferences.getString(_draftKey);
    if (draftJson != null) {
      try {
        final form = CompanyFormModel.fromJson(json.decode(draftJson));
        if (isClosed) return;
        emit(CompanyCreationInitial(form));
      } catch (_) {
        // Ignore corrupted draft
      }
    }
  }

  Future<void> _saveDraft(CompanyFormModel form) async {
    await sharedPreferences.setString(_draftKey, json.encode(form.toJson()));
  }

  void updateForm(CompanyFormModel form) {
    if (isClosed) return;
    emit(CompanyCreationInitial(form));
    _saveDraft(form);
  }

  Future<void> createCompany() async {
    if (isClosed) return;
    emit(CompanyCreationLoading(state.form));
    final result = await doCreateCompany(state.form);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyCreationError(state.form, failure.message)),
      (id) {
        final newForm =
            state.form.copyWith(createdCompanyId: id, currentStep: 1);
        emit(CompanyCreationInitial(newForm));
        _saveDraft(newForm);
      },
    );
  }

  Future<void> createHeadquarter() async {
    if (state.form.createdCompanyId == null) return;

    if (isClosed) return;
    emit(CompanyCreationLoading(state.form));
    final result =
        await doCreateHeadquarter(state.form, state.form.createdCompanyId!);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyCreationError(state.form, failure.message)),
      (id) {
        final newForm =
            state.form.copyWith(createdHeadquarterId: id, currentStep: 2);
        emit(CompanyCreationInitial(newForm));
        _saveDraft(newForm);
      },
    );
  }

  Future<void> createTimeConfig() async {
    if (state.form.createdHeadquarterId == null) return;

    if (isClosed) return;
    emit(CompanyCreationLoading(state.form));
    final result =
        await doCreateTimeConfig(state.form, state.form.createdHeadquarterId!);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CompanyCreationError(state.form, failure.message)),
      (_) async {
        await sharedPreferences.remove(_draftKey);
        if (isClosed) return;
        emit(CompanyCreationSuccess(state.form));
      },
    );
  }

  void resetDraft() async {
    await sharedPreferences.remove(_draftKey);
    if (isClosed) return;
    emit(const CompanyCreationInitial(CompanyFormModel()));
  }
}
