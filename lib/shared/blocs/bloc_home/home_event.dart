part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class DoGetServicesEvent extends HomeEvent {

  final FilterServiceModel filterService;
  final List<HeadquarterModel> headquarters;

  const DoGetServicesEvent(
      {this.headquarters = const [],
      required this.filterService});

  @override
  List<Object> get props =>
      [headquarters, filterService];
}

class DoResetHomeEvent extends HomeEvent {
  const DoResetHomeEvent();
  @override
  List<Object> get props => [];
}

class DoGetNotificationEvent extends HomeEvent {
  final String? nextUrl;
  final bool isFirstLoad;
  final int? companyId;
  const DoGetNotificationEvent(this.nextUrl, [this.isFirstLoad = false, this.companyId]);

  @override
  List<Object> get props => [nextUrl ?? "", isFirstLoad, companyId ?? -1];
}

class SetStateHomeEvent extends HomeEvent {
  final HomeState newState;
  const SetStateHomeEvent(this.newState);

  @override
  List<Object> get props => [newState];
}


class DoCreateUserAddressEvent extends HomeEvent {
  final AddressModel address;
  const DoCreateUserAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

class DoGetUserAddressesEvent extends HomeEvent {

}

class DoUpdateUserAddressesEvent extends HomeEvent {
  final AddressModel address;
  const DoUpdateUserAddressesEvent(this.address);
}

class DoGetUnreadCountEvent extends HomeEvent {
  final int? companyId;
  const DoGetUnreadCountEvent({this.companyId});

  @override
  List<Object> get props => [companyId ?? -1];
}

class DoDeleteUserAddressEvent extends HomeEvent {
  final int addressId;
  const DoDeleteUserAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}