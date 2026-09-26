import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

abstract class ProfileDatasource {}

mixin CreateUserAddressMixin {
  Future<AddressModel> createUserAddress(
      {required String authToken, required AddressModel address});
}

mixin GetUserAddressesMixin {
  Future<List<AddressModel>> getUserAddresses({required String authToken});
}

mixin UpdateUserAddressMixin {
  Future<String> updateUserAddress(
      {required String? authToken, required AddressModel address});
}

mixin DeleteUserAddressMixin {
  Future<void> deleteUserAddress(
      {required String authToken, required int addressId});
}

mixin UpdateUserInformationMixin {
  Future<UserModel> updateUserInformation(
      {required String authToken,
      required Map<String, dynamic> data,
      bool isMultipart = false});
}

mixin RequestCreatePasswordMixin {
  Future<void> requestCreatePassword({required String authToken});
}

mixin ConfirmCreatePasswordMixin {
  Future<void> confirmCreatePassword(
      {required String authToken,
      required String code,
      required String newPassword});
}

mixin UpdateUserPasswordMixin {
  Future<void> updateUserPassword(
      {required String authToken,
      required String oldPassword,
      required String newPassword});
}

abstract class ProfileApiDatasource extends ProfileDatasource
    with
        CreateUserAddressMixin,
        GetUserAddressesMixin,
        UpdateUserAddressMixin,
        DeleteUserAddressMixin,
        UpdateUserInformationMixin,
        RequestCreatePasswordMixin,
        ConfirmCreatePasswordMixin,
        UpdateUserPasswordMixin {}
