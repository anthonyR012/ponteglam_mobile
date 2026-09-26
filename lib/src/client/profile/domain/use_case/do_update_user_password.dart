import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoUpdateUserPassword {
  final ProfileRepository profileRepository;
  DoUpdateUserPassword(this.profileRepository);

  Future<Either<Failure, void>> call(
      {required IStorage storage,
      required String oldPassword,
      required String newPassword}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    return profileRepository.updateUserPassword(
        authToken: token, oldPassword: oldPassword, newPassword: newPassword);
  }
}
