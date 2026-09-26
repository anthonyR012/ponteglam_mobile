import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_delete_user_address.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_get_user_addresses.dart';
import 'package:ponte_glam/src/client/profile/domain/use_case/do_update_user_address.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DoGetServices doGetServices;
  final DoGetNotifications doGetNotifications;
  final DoCreateUserAddress doCreateUserAddress;
  final DoGetUserAddresses doGetUserAddresses;
  final DoUpdateUserAddresses doUpdateUserAddress;
  final DoDeleteUserAddress doDeleteUserAddress;
  final DoGetUnreadCount doGetUnreadCount;

  String? nextNotificationUrl;
  List<NotificationModel> notifications = [];
  int unreadCount = 0;

  HomeBloc(
      this.doGetServices,
      this.doGetNotifications,
      this.doCreateUserAddress,
      this.doGetUserAddresses,
      this.doUpdateUserAddress,
      this.doDeleteUserAddress,
      this.doGetUnreadCount)
      : super(HomeInitial()) {
    on<DoGetServicesEvent>(_doGetServices);
    on<DoResetHomeEvent>(_doResetService);
    on<DoGetNotificationEvent>(_doGetNotificationList);
    on<DoCreateUserAddressEvent>(_doCreateUserAddress);
    on<DoGetUserAddressesEvent>(_doGetUserAddresses);
    on<DoUpdateUserAddressesEvent>(_doUpdateUserAddress);
    on<DoDeleteUserAddressEvent>(_doDeleteUserAddress);
    on<SetStateHomeEvent>((event, emit) => emit(event.newState));
    on<DoGetUnreadCountEvent>(_doGetUnreadCount);
  }

  void _doGetServices(DoGetServicesEvent event, Emitter<HomeState> emit) async {
    final filter = event.filterService;
    if (filter.isRefresh) {
      emit(HomeIsRefreshing());
      assert(
          event.headquarters.isNotEmpty, "Must provide a refresh headquarters");
      emit(GetHeadquartersLoaded(event.headquarters));
      return;
    }
    if (filter.nextUrl != null) {
      emit(HomeIsLoadingMore());
    } else {
      emit(HomeIsLoading());
      getIt<HeadquarterCubit>().headquarters = [];
    }
    final ParamsDoGetServices params = ParamsDoGetServices(
        storage: getIt<IStorage>(),
        filter: filter,
        geoDevice: getIt<GeoDevice>());
    final failureOrServices = await doGetServices(params: params);
    emit(_failureOrSucess(failureOrServices, (paginator) {
      final headquarterCubit = getIt<HeadquarterCubit>();
      if (filter.nextUrl == null) {
        headquarterCubit.nextUrlServices = paginator.next;
        headquarterCubit.headquarters = paginator.headquarters;
      } else {
        headquarterCubit.headquarters.addAll(paginator.headquarters);
        headquarterCubit.nextUrlServices = paginator.next;
      }
      return GetHeadquartersLoaded(headquarterCubit.headquarters);
    }));
  }

  void _doResetService(DoResetHomeEvent event, Emitter<HomeState> emit) {
    emit(HomeInitial());
  }

  void _doGetNotificationList(
      DoGetNotificationEvent event, Emitter<HomeState> emit) async {
    if (notifications.isNotEmpty && event.isFirstLoad) {
      emit(GetNotificationsLoaded(notifications));
      return;
    }
    if (event.nextUrl != null) {
      emit(HomeIsLoadingMore());
    } else {
      emit(HomeIsLoading());
    }
    final state = await getNotifications(event.nextUrl, event.companyId);
    emit(state);
  }

  void _doCreateUserAddress(
      DoCreateUserAddressEvent event, Emitter<HomeState> emit) async {
    emit(HomeIsLoading());
    final failureOrAddress = await doCreateUserAddress(
        storage: getIt<IStorage>(), address: event.address);
    emit(_failureOrSucess<AddressModel>(
        failureOrAddress, (saved) => AddressUserWasCreated(saved)));
  }

  void _doGetUserAddresses(
      DoGetUserAddressesEvent event, Emitter<HomeState> emit) async {
    emit(HomeIsLoading());
    final failureOrAddresses =
        await doGetUserAddresses(storage: getIt<IStorage>());
    emit(_failureOrSucess<List<AddressModel>>(
        failureOrAddresses, (addresses) => GetUserAddressesLoaded(addresses)));
  }

  void _doUpdateUserAddress(
      DoUpdateUserAddressesEvent event, Emitter<HomeState> emit) async {
    emit(HomeIsLoading());
    final failureOrAddresses = await doUpdateUserAddress(
        storage: getIt<IStorage>(), address: event.address);
    emit(_failureOrSucess<String>(
        failureOrAddresses, (addresses) => UpdatedUserAddress(addresses)));
  }

  void _doDeleteUserAddress(
      DoDeleteUserAddressEvent event, Emitter<HomeState> emit) async {
    emit(HomeIsLoading());
    final result = await doDeleteUserAddress(
        storage: getIt<IStorage>(), addressId: event.addressId);
    emit(result.fold(
      (failure) => HomeError(failure.message),
      (_) => const AddressDeleted(),
    ));
  }

  void _doGetUnreadCount(
      DoGetUnreadCountEvent event, Emitter<HomeState> emit) async {
    final result = await doGetUnreadCount(companyId: event.companyId);
    result.fold(
      (_) {},
      (count) {
        unreadCount = count;
        emit(UnreadCountUpdated(count));
      },
    );
  }

  Future<HomeState> getNotifications([String? next, int? companyId]) async {
    final failureOrNotifications = await doGetNotifications(
        storage: getIt<IStorage>(), nextUrl: next, companyId: companyId);
    return _failureOrSucess(failureOrNotifications, (paginator) {
      if (next == null) {
        nextNotificationUrl = paginator.next;
        notifications = paginator.results;
      } else {
        notifications.addAll(paginator.results);
        nextNotificationUrl = paginator.next;
      }
      return GetNotificationsLoaded(notifications);
    });
  }

  HomeState _failureOrSucess<T>(
      Either<Failure, T> failureOrSucess, HomeState Function(T) onSuccess) {
    return failureOrSucess.fold(
        (failure) => HomeError(failure.message), onSuccess);
  }
}
