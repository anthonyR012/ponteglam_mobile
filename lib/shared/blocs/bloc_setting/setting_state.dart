part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {}

class SettingIsLoading extends SettingState {}

class SettingError extends SettingState {
  final String messageError;

  const SettingError(this.messageError);
  @override
  List<Object> get props => [messageError];
}

class GetAmenitiesLoaded extends SettingState {
  final List<AmenityModel> amenities;
  const GetAmenitiesLoaded(this.amenities);
  @override
  List<Object> get props => [amenities];
}

class GetAmenityLoaded extends SettingState {
  final AmenityModel amenity;
  const GetAmenityLoaded(this.amenity);
  @override
  List<Object> get props => [amenity];
}

class GetCategoriesLoaded extends SettingState {
  final List<CategoryModel> categories;
  const GetCategoriesLoaded(this.categories);
  @override
  List<Object> get props => [categories];
}

class GetTypesLoaded extends SettingState {
  final List<TypeModel> types;
  const GetTypesLoaded(this.types);
  @override
  List<Object> get props => [types];
}
