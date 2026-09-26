import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final DoGetCategories doGetCategories;
  final DoGetTypes doGetTypes;
  final DoGetTypesByCategory doGetTypesByCategory;
  final DoGetAmenities doGetAmenities;
  final SignInRepository signInRepository;
 
  CategoryModel? categorySelected;
  UserModel? user;

  SettingBloc(
      this.doGetCategories,
      this.doGetTypes,
      this.doGetTypesByCategory,
      this.doGetAmenities,
      this.signInRepository)
      : super(SettingInitial()) {
    on<DoGetCategoriesEvent>(_doGetCategories);
    on<DoGetTypesEvent>(_doGetTypes);
    on<DoGetAmenitiesEvent>(_doGetAmenities);
    on<DoResetSettingEvent>(_doResetSettingEvent);
    on<DoUpdateUserInfoEvent>(_doUpdateUserInfoEvent);
  }

  void _doGetCategories(
      DoGetCategoriesEvent event, Emitter<SettingState> emit) async {
    emit(SettingIsLoading());
    final failureOrGetCategories = await doGetCategories();
    emit(_failureOrSucess<List<CategoryModel>>(failureOrGetCategories,
        (categories) => GetCategoriesLoaded(categories)));
  }

  void _doGetTypes(DoGetTypesEvent event, Emitter<SettingState> emit) async {
    emit(SettingIsLoading());
    final failureOrGetTypes = await doGetTypes();
    emit(_failureOrSucess<List<TypeModel>>(
        failureOrGetTypes, (amenities) => GetTypesLoaded(amenities)));
  }

  void _doGetAmenities(
      DoGetAmenitiesEvent event, Emitter<SettingState> emit) async {
    emit(SettingIsLoading());
    final failureOrGetAmenities =
        await doGetAmenities(idAmenities: event.idAmenities);
    emit(_failureOrSucess<List<AmenityModel>>(
        failureOrGetAmenities, (amenities) => GetAmenitiesLoaded(amenities)));
  }

  void _doResetSettingEvent(
      DoResetSettingEvent event, Emitter<SettingState> emit) {
    if (event.newState != null) {
      emit(event.newState!);
      return;
    }
    categorySelected = null;
    user = null;
    emit(SettingInitial());
  }

  void _doUpdateUserInfoEvent(
      DoUpdateUserInfoEvent event, Emitter<SettingState> emit) async {
    user = event.user;
    await signInRepository.saveUser(user: user!, datasource: Repository.local);
    emit(SettingInitial()); // Triggers a state change
  }

  SettingState _failureOrSucess<T>(
      Either<Failure, T> failureOrSucess, SettingState Function(T) onSuccess) {
    return failureOrSucess.fold(
        (failure) => SettingError(failure.message), onSuccess);
  }
}
