part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

class HomeIsLoading extends HomeState {}

class HomeIsRefreshing extends HomeState {}

class HomeIsLoadingMore extends HomeState {}

class HomeError extends HomeState {
  final String messageError;

  const HomeError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

class GetHeadquartersLoaded extends HomeState {
  final List<HeadquarterModel> headquarters;

  const GetHeadquartersLoaded(this.headquarters);
}


class GetNotificationsLoaded extends HomeState {
  final List<NotificationModel> notifications;

  const GetNotificationsLoaded(this.notifications);
}

class AddressUserWasCreated extends HomeState {
  final AddressModel address;
  const AddressUserWasCreated(this.address);

  @override
  List<Object> get props => [address];
}


class GetUserAddressesLoaded extends HomeState {
  final List<AddressModel> addresses;

  const GetUserAddressesLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
} 


class UpdatedUserAddress extends HomeState {
  final String message;
  const UpdatedUserAddress(this.message);

  @override
  List<Object> get props => [message];
}

class UnreadCountUpdated extends HomeState {
  final int count;
  const UnreadCountUpdated(this.count);

  @override
  List<Object> get props => [count];
}

class AddressDeleted extends HomeState {
  const AddressDeleted();
  @override
  List<Object> get props => [];
}