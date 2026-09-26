import 'package:ponte_glam/shared/model/user_model.dart';

enum ProfileStatus { initial, loading, success, failure }

enum ProfileAction {
  idle,
  updateInfo,
  requestPasswordCode,
  confirmPasswordCode,
  updatePassword,
  uploadPicture,
}

class ProfileState {
  final ProfileStatus status;
  final ProfileAction action;
  final String? errorMessage;
  final UserModel? updatedUser; // To pass back the updated user info

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.action = ProfileAction.idle,
    this.errorMessage,
    this.updatedUser,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileAction? action,
    String? errorMessage,
    UserModel? updatedUser,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      action: action ?? this.action,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      updatedUser: updatedUser ?? this.updatedUser,
    );
  }
}
