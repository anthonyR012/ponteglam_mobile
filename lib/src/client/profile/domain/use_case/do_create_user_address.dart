import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';

class DoCreateUserAddress {
  final ProfileRepository profileRepository;
  DoCreateUserAddress(this.profileRepository);

  Future<Either<Failure, AddressModel>> call(
      {required IStorage storage, required AddressModel address}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    final state = await profileRepository.createUserAddress(
        authToken: token, address: address);
    return state;
  }
}
