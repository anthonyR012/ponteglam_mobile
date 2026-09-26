import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/src/client/profile/data/datasource/profile_datasource.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class ProfileImplement extends ProfileRepository {
  final ProfileApiDatasource profileApiDatasource;
  ProfileImplement(this.profileApiDatasource);

  @override
  Future<Either<Failure, AddressModel>> createUserAddress(
      {required String authToken, required AddressModel address}) async {
    try {
      final AddressModel addressCreated = await profileApiDatasource
          .createUserAddress(authToken: authToken, address: address);
      return Right(addressCreated);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AddressModel>>> getUserAddresses(
      {required String authToken}) async {
    try {
      final List<AddressModel> addresses =
          await profileApiDatasource.getUserAddresses(authToken: authToken);
      return Right(addresses);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateUserAddress(
      {required String? authToken, required AddressModel address}) async {
    try {
      final String addresses = await profileApiDatasource.updateUserAddress(
          authToken: authToken, address: address);
      return Right(addresses);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAddress(
      {required String authToken, required int addressId}) async {
    try {
      await profileApiDatasource.deleteUserAddress(
          authToken: authToken, addressId: addressId);
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUserInformation(
      {required String authToken,
      required Map<String, dynamic> data,
      bool isMultipart = false}) async {
    try {
      final UserModel user = await profileApiDatasource.updateUserInformation(
          authToken: authToken, data: data, isMultipart: isMultipart);
      return Right(user);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestCreatePassword(
      {required String authToken}) async {
    try {
      await profileApiDatasource.requestCreatePassword(authToken: authToken);
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmCreatePassword(
      {required String authToken,
      required String code,
      required String newPassword}) async {
    try {
      await profileApiDatasource.confirmCreatePassword(
          authToken: authToken, code: code, newPassword: newPassword);
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserPassword(
      {required String authToken,
      required String oldPassword,
      required String newPassword}) async {
    try {
      await profileApiDatasource.updateUserPassword(
          authToken: authToken,
          oldPassword: oldPassword,
          newPassword: newPassword);
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
