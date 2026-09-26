import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoConfirmCreatePassword {
  final ProfileRepository profileRepository;
  DoConfirmCreatePassword(this.profileRepository);

  Future<Either<Failure, void>> call(
      {required IStorage storage,
      required String code,
      required String newPassword}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    return profileRepository.confirmCreatePassword(
        authToken: token, code: code, newPassword: newPassword);
  }
}
