import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoDeleteUserAddress {
  final ProfileRepository profileRepository;
  DoDeleteUserAddress(this.profileRepository);

  Future<Either<Failure, void>> call(
      {required IStorage storage, required int addressId}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    return profileRepository.deleteUserAddress(
        authToken: token, addressId: addressId);
  }
}
