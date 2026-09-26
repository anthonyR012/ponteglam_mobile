import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';

class DoGetUserAddresses {
  final ProfileRepository profileRepository;
  DoGetUserAddresses(this.profileRepository);

  Future<Either<Failure, List<AddressModel>>> call(
      {required IStorage storage}) async {
    final token = await storage.read(key: keyAuthToken) ?? "";
    final state = await profileRepository.getUserAddresses(authToken: token);
    return state;
  }
}
