import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';

class DoUpdateUserAddresses {
  final ProfileRepository profileRepository;
  DoUpdateUserAddresses(this.profileRepository);

  Future<Either<Failure, String>> call(
      {required IStorage storage, required AddressModel address}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    final state = await profileRepository.updateUserAddress(
        authToken: token, address: address);
    return state;
  }
}
