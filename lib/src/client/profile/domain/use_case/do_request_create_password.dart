import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoRequestCreatePassword {
  final ProfileRepository profileRepository;
  DoRequestCreatePassword(this.profileRepository);

  Future<Either<Failure, void>> call({required IStorage storage}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    return profileRepository.requestCreatePassword(authToken: token);
  }
}
