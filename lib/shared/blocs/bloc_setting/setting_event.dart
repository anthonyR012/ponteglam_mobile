part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class DoGetCategoriesEvent extends SettingEvent {
  const DoGetCategoriesEvent();
}

class DoGetTypesEvent extends SettingEvent {
  const DoGetTypesEvent();
}

class DoGetAmenitiesEvent extends SettingEvent {
  final List<int> idAmenities;

  const DoGetAmenitiesEvent({this.idAmenities = const []});

  @override
  List<Object> get props => [idAmenities];
}

class DoResetSettingEvent extends SettingEvent {
  const DoResetSettingEvent({this.newState});
  final SettingState? newState;

  @override
  List<Object> get props => [];
}

class DoUpdateUserInfoEvent extends SettingEvent {
  final UserModel user;
  const DoUpdateUserInfoEvent(this.user);

  @override
  List<Object> get props => [user];
}
