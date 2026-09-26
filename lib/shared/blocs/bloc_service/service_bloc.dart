import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final DoMakeCall makeCall;
  FilterServiceModel filterService = const FilterServiceModel();

  ServiceBloc(this.makeCall) : super(ServiceInitial()) {
    on<MakeCallServiceEvent>(_makeCallServiceEvent, transformer: droppable());
    on<DoFilterServiceEvent>(_doFilterServiceEvent, transformer: droppable());
    on<DoResetServiceEvent>(_doResetServiceEvent);
    on<UpdateFilterEvent>(_onUpdateFilterEvent);
  }

  FutureOr<void> _onUpdateFilterEvent(
      UpdateFilterEvent event, Emitter<ServiceState> emit) {
    filterService = event.filter;
    emit(GetFilterServiceLoaded(filterService));
  }

  FutureOr<void> _doFilterServiceEvent(
      DoFilterServiceEvent event, Emitter<ServiceState> emit) {}

  FutureOr<void> _makeCallServiceEvent(
      MakeCallServiceEvent event, Emitter<ServiceState> emit) async {
    final currentState = state;
    final failureOrMakeCall = await makeCall(phoneNumber: event.phoneNumber);
    if (failureOrMakeCall.isRight()) {
      emit(const MakeCallSuccess());
      return;
    }
    emit(MakeCallError(getIt<AppLocalizations>().failureWentWrong));
    emit(currentState);
  }

  String doCalculateDurationInMinutes(
      {required int? duration, bool minChar = false}) {
    int hourDouble = 0;
    String prefix = "";
    final appLocalizations = getIt<AppLocalizations>();
    if (duration == null) return "";
    if (duration < 60) {
      hourDouble = duration;
      prefix =
          minChar ? appLocalizations.titleMin : appLocalizations.titleMinutes;
    } else {
      hourDouble = duration ~/ 60;
      if (hourDouble == 1) {
        prefix = minChar
            ? appLocalizations.titleHr
            : appLocalizations.titleHr.replaceAll("s", "");
      } else {
        prefix = minChar ? appLocalizations.titleHr : appLocalizations.titleHr;
      }
    }
    return '${hourDouble.toStringAsFixed(0)} $prefix';
  }

  FutureOr<void> _doResetServiceEvent(
      DoResetServiceEvent event, Emitter<ServiceState> emit) {
    filterService = const FilterServiceModel();
    emit(GetFilterServiceLoaded(filterService));
  }

  void resetFilter() {
    add(const DoResetServiceEvent());
  }

  void setFilter(
      {double? rating,
      String? query,
      bool? onlyOffers,
      bool? onlyVerified,
      String? nextUrl,
      bool? nearMe,
      bool? onlyHomeService,
      bool? isRefresh,
      bool? isFirstLoad = false,
      double? minPrice,
      double? maxPrice,
      List<String>? availableFor,
      required BuildContext context}) {
    final categoryId = context.read<SettingBloc>().categorySelected?.id;
    final newFilter = filterService.copyWith(
        category: categoryId,
        rating: rating,
        query: query,
        onlyOffers: onlyOffers,
        onlyVerified: onlyVerified,
        nextUrl: nextUrl,
        nearMe: nearMe,
        onlyHomeService: onlyHomeService,
        isRefresh: isRefresh,
        isFirstLoad: isFirstLoad ?? false,
        minPrice: minPrice,
        maxPrice: maxPrice,
        availableFor: availableFor);

    add(UpdateFilterEvent(newFilter));

    context
        .read<HomeBloc>()
        .add(DoGetServicesEvent(filterService: newFilter));
  }
}
