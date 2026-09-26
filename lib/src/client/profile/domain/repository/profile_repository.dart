import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, AddressModel>> createUserAddress(
      {required String authToken, required AddressModel address});
  Future<Either<Failure, List<AddressModel>>> getUserAddresses(
      {required String authToken});
  Future<Either<Failure, String>> updateUserAddress(
      {required String? authToken, required AddressModel address});
  Future<Either<Failure, void>> deleteUserAddress(
      {required String authToken, required int addressId});
  Future<Either<Failure, UserModel>> updateUserInformation(
      {required String authToken, required Map<String, dynamic> data, bool isMultipart = false});
  Future<Either<Failure, void>> requestCreatePassword({required String authToken});
  Future<Either<Failure, void>> confirmCreatePassword({required String authToken, required String code, required String newPassword});
  Future<Either<Failure, void>> updateUserPassword({required String authToken, required String oldPassword, required String newPassword});
}
