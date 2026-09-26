import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoUpdateUserInformation {
  final ProfileRepository profileRepository;
  DoUpdateUserInformation(this.profileRepository);

  Future<Either<Failure, UserModel>> call(
      {required IStorage storage,
      required Map<String, dynamic> data,
      bool isMultipart = false}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    return profileRepository.updateUserInformation(
        authToken: token, data: data, isMultipart: isMultipart);
  }
}
