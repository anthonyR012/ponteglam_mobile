import 'package:ponte_glam/di/shared_imports.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.doUpdateUserInformation,
    required this.doRequestCreatePassword,
    required this.doConfirmCreatePassword,
    required this.doUpdateUserPassword,
  }) : super(const ProfileState());

  final DoUpdateUserInformation doUpdateUserInformation;
  final DoRequestCreatePassword doRequestCreatePassword;
  final DoConfirmCreatePassword doConfirmCreatePassword;
  final DoUpdateUserPassword doUpdateUserPassword;

  Future<void> updateInformation(Map<String, dynamic> data) async {
    emit(state.copyWith(
        status: ProfileStatus.loading,
        action: ProfileAction.updateInfo,
        clearError: true));

    final result = await doUpdateUserInformation(
        storage: getIt<IStorage>(), data: data, isMultipart: false);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (updatedUser) => emit(state.copyWith(
        status: ProfileStatus.success,
        updatedUser: updatedUser,
      )),
    );
  }

  Future<void> uploadPicture(String path) async {
    emit(state.copyWith(
        status: ProfileStatus.loading,
        action: ProfileAction.uploadPicture,
        clearError: true));

    final result = await doUpdateUserInformation(
        storage: getIt<IStorage>(), data: {'picture': path}, isMultipart: true);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (updatedUser) => emit(state.copyWith(
        status: ProfileStatus.success,
        updatedUser: updatedUser,
      )),
    );
  }

  Future<void> requestPasswordCode() async {
    emit(state.copyWith(
        status: ProfileStatus.loading,
        action: ProfileAction.requestPasswordCode,
        clearError: true));

    final result = await doRequestCreatePassword(storage: getIt<IStorage>());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }

  Future<void> confirmPasswordCode(String code, String newPassword) async {
    emit(state.copyWith(
        status: ProfileStatus.loading,
        action: ProfileAction.confirmPasswordCode,
        clearError: true));

    final result = await doConfirmCreatePassword(
        storage: getIt<IStorage>(), code: code, newPassword: newPassword);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }

  Future<void> updateUserPassword(
      String oldPassword, String newPassword) async {
    emit(state.copyWith(
        status: ProfileStatus.loading,
        action: ProfileAction.updatePassword,
        clearError: true));

    final result = await doUpdateUserPassword(
        storage: getIt<IStorage>(),
        oldPassword: oldPassword,
        newPassword: newPassword);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }
}
