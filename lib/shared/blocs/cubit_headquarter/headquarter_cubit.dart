import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
part 'headquarter_state.dart';

class HeadquarterCubit extends Cubit<HeadquarterState> {
  HeadquarterCubit(this.interactionCall) : super(HeadquarterInitial());
  String? nextUrlServices;
  List<HeadquarterModel> headquarters = [];
  final DoInteractionHeadquarter interactionCall;

  void doInteractEmit(
      {required Interaction interaction,
      required int headquarterCompanyId}) async {
    if (headquarters.isEmpty) {
      emit(HeadquarterInitial());
      return;
    }
    emit(HeadquarterIsLoading());
    final result = await doInteract(
        interaction: interaction, headquarterCompanyId: headquarterCompanyId);
    emit(result);
  }

  Future<HeadquarterState> doInteract(
      {required Interaction interaction,
      required int headquarterCompanyId}) async {
    ParamsDoInteractionHeadquarter params = ParamsDoInteractionHeadquarter(
        interaction: interaction,
        headquarterCompanyId: headquarterCompanyId,
        storage: getIt<IStorage>());
    final failureOrSucess = await interactionCall(params: params);
    if (failureOrSucess.isRight()) {
      final index = headquarters
          .indexWhere((element) => element.id == headquarterCompanyId);
      headquarters[index] =
          headquarters[index].copyWith(like: interaction == Interaction.like);
    }
    return _failureOrSucess<String>(
        failureOrSucess, (response) => InteractiveLoaded(response));
  }

  ServiceModel getServiceByIndex(
      {required int index, required int indexHeadquarter}) {
    final currentHeadquarter = headquarters[indexHeadquarter];
    return currentHeadquarter.services[index];
  }

  HeadquarterModel? getHeadquarterByIndex({required int index}) {
    if (index >= 0 && index < headquarters.length) {
      return headquarters[index];
    }
    return null;
  }

  HeadquarterModel? getHeadquarterById({required int id}) {
    HeadquarterModel headquarter = headquarters.firstWhere(
        (element) => element.id == id,
        orElse: () => HeadquarterModel.empty());
    if (headquarter.id == 0) {
      return null;
    }
    return headquarter;
  }

  void resetState() {
    emit(HeadquarterInitial());
  }

  void setState(HeadquarterState state) {
    emit(state);
  }

  HeadquarterState _failureOrSucess<T>(Either<Failure, T> failureOrSucess,
      HeadquarterState Function(T) onSuccess) {
    return failureOrSucess.fold(
        (failure) => HeadquarterError(failure.message), onSuccess);
  }
}
