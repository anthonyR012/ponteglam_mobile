import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/domain/use_case/do_create_company_use_cases.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_get_week_configuration.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/use_case/do_update_headquarter.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_creation_state.dart';

class HeadquarterCreationCubit extends Cubit<HeadquarterCreationState> {
  final SharedPreferences sharedPreferences;
  final DoCreateHeadquarter doCreateHeadquarter;
  final DoCreateTimeConfig doCreateTimeConfig;
  final DoUpdateHeadquarter doUpdateHeadquarter;
  final DoGetWeekConfiguration doGetWeekConfiguration;
  final int companyId;
  final bool isEditing;

  static const String _draftKey = keyHeadquarterDraft;

  HeadquarterCreationCubit({
    required this.companyId,
    required this.sharedPreferences,
    required this.doCreateHeadquarter,
    required this.doCreateTimeConfig,
    required this.doUpdateHeadquarter,
    required this.doGetWeekConfiguration,
    this.isEditing = false,
    HeadquarterFormModel? initialForm,
  }) : super(HeadquarterCreationInitial(
          initialForm ?? HeadquarterFormModel(companyId: companyId),
        )) {
    if (!isEditing) _loadDraft();
  }

  void _loadDraft() {
    final draftJson = sharedPreferences.getString(_draftKey);
    if (draftJson != null) {
      try {
        final form = HeadquarterFormModel.fromJson(json.decode(draftJson));
        if (form.companyId == companyId) {
          if (isClosed) return;
          emit(HeadquarterCreationInitial(form));
        }
      } catch (_) {
        // Ignore corrupted draft
      }
    }
  }

  Future<void> _saveDraft(HeadquarterFormModel form) async {
    if (isEditing) return;
    await sharedPreferences.setString(_draftKey, json.encode(form.toJson()));
  }

  void updateForm(HeadquarterFormModel form) {
    if (isClosed) return;
    emit(HeadquarterCreationInitial(form));
    _saveDraft(form);
  }

  CompanyFormModel _mapToCompanyForm(HeadquarterFormModel form) {
    return CompanyFormModel(
      headquarterName: form.headquarterName,
      headquarterPhone: form.headquarterPhone,
      headquarterAddress: form.headquarterAddress,
      headquarterLatitude: form.headquarterLatitude,
      headquarterLongitude: form.headquarterLongitude,
      cityId: form.cityId,
      additionalImagesPaths: form.additionalImagesPaths,
      workHours: form.workHours,
    );
  }

  Future<void> loadWeekConfiguration() async {
    final hqId = state.form.headquarterId;
    if (hqId == null) return;
    if (isClosed) return;

    emit(HeadquarterCreationLoading(state.form));
    final result = await doGetWeekConfiguration(headquarterId: hqId);
    if (isClosed) return;

    result.fold(
      (_) => emit(HeadquarterCreationInitial(state.form)),
      (schedule) {
        final updated = state.form.copyWith(workHours: schedule);
        emit(HeadquarterCreationInitial(updated));
      },
    );
  }

  Future<void> createHeadquarter() async {
    if (isEditing) {
      await _updateHeadquarter();
      return;
    }

    if (isClosed) return;
    emit(HeadquarterCreationLoading(state.form));

    final companyForm = _mapToCompanyForm(state.form);
    final result = await doCreateHeadquarter(companyForm, state.form.companyId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(HeadquarterCreationError(state.form, failure.message)),
      (id) {
        final newForm = state.form.copyWith(createdHeadquarterId: id, currentStep: 1);
        emit(HeadquarterCreationInitial(newForm));
        _saveDraft(newForm);
      },
    );
  }

  Future<void> _updateHeadquarter() async {
    final hqId = state.form.headquarterId;
    if (hqId == null) return;

    if (isClosed) return;
    emit(HeadquarterCreationLoading(state.form));

    final result = await doUpdateHeadquarter(
      headquarterId: hqId,
      form: state.form,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(HeadquarterCreationError(state.form, failure.message)),
      (_) {
        final newForm = state.form.copyWith(currentStep: 1);
        emit(HeadquarterCreationInitial(newForm));
      },
    );
  }

  Future<void> createTimeConfig() async {
    final hqId = isEditing
        ? state.form.headquarterId
        : state.form.createdHeadquarterId;

    if (hqId == null) return;

    if (isClosed) return;
    emit(HeadquarterCreationLoading(state.form));

    final companyForm = _mapToCompanyForm(state.form);
    final result = await doCreateTimeConfig(companyForm, hqId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(HeadquarterCreationError(state.form, failure.message)),
      (_) async {
        if (!isEditing) await sharedPreferences.remove(_draftKey);
        if (isClosed) return;
        emit(HeadquarterCreationSuccess(state.form));
      },
    );
  }

  void resetDraft() async {
    await sharedPreferences.remove(_draftKey);
    if (isClosed) return;
    emit(HeadquarterCreationInitial(HeadquarterFormModel(companyId: companyId)));
  }
}
