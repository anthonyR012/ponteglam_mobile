import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_amenities.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_categories.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_types_by_category.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_create_service.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_update_service.dart';
import 'package:ponte_glam/src/supplier/service/domain/use_case/do_delete_service.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_state.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

class ServiceCreationCubit extends Cubit<ServiceCreationState> {
  final DoCreateService doCreateService;
  final DoUpdateService doUpdateService;
  final DoGetCategories doGetCategories;
  final DoGetTypesByCategory doGetTypesByCategory;

  List<CategoryModel> categories = [];
  List<TypeModel> genderTypes = [];
  List<TypeModel> stateTypes = [];
  List<AmenityModel> allAmenities = [];

  ServiceModel? serviceToEdit;

  final DoGetAmenities doGetAmenities;
  final DoDeleteService doDeleteService;

  ServiceCreationCubit({
    required this.doCreateService,
    required this.doUpdateService,
    required this.doGetCategories,
    required this.doGetTypesByCategory,
    required this.doGetAmenities,
    required this.doDeleteService,
  }) : super(const ServiceCreationInitial(ServiceCreationFormModel()));

  void initMode(ServiceModel? service) {
    serviceToEdit = service;
    if (service != null && !isClosed) {
      final form = ServiceCreationFormModel(
        name: service.name,
        description: service.description,
        price: service.price.toDouble(),
        confirmationIn: service.confirmationIn,
        rememberIn: service.rememberIn,
        onlyHomeService: service.onlyHomeService,
        homeServicePrice: service.homeServicePrice,
        serviceCategoryId: service.categoryServiceId,
        genderId: service.genderId,
        stateId: service.stateId,
        imagePaths: service.images,
        amenityIds: service.amenities,
      );
      emit(ServiceCreationInitial(form));
    }
  }

  Future<void> loadInitialData() async {
    if (isClosed) return;
    emit(ServiceCreationLoading(state.form));

    try {
      final categoriesResult = await doGetCategories();
      final genderResult = await doGetTypesByCategory(category: 'gender_service');
      final stateResult = await doGetTypesByCategory(category: 'status_service');
      final amenitiesResult = await doGetAmenities();

      categoriesResult.fold((_) {}, (cats) => categories = cats);
      genderResult.fold((_) {}, (types) => genderTypes = types);
      stateResult.fold((_) {}, (types) => stateTypes = types);
      amenitiesResult.fold((_) {}, (amenities) => allAmenities = amenities);
    } catch (_) {}

    if (isClosed) return;
    emit(ServiceCreationInitial(state.form));
  }

  void updateForm(ServiceCreationFormModel form) {
    if (isClosed) return;
    emit(ServiceCreationInitial(form));
  }

  Future<void> submit(int headquarterId) async {
    if (isClosed) return;
    emit(ServiceCreationLoading(state.form));

    final result = serviceToEdit == null
        ? await doCreateService(
            form: state.form,
            headquarterId: headquarterId,
          )
        : await doUpdateService(
            serviceId: serviceToEdit!.id,
            form: state.form,
            headquarterId: headquarterId,
          );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ServiceCreationError(state.form, failure.message)),
      (id) => emit(ServiceCreationSuccess(state.form, id)),
    );
  }

  Future<void> deleteService(int serviceId) async {
    if (isClosed) return;
    emit(ServiceCreationLoading(state.form));

    final result = await doDeleteService(serviceId: serviceId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(ServiceCreationError(state.form, failure.message)),
      (_) => emit(ServiceDeletionSuccess(state.form)),
    );
  }
}
