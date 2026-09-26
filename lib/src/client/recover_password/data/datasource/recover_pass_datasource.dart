import 'package:ponte_glam/shared/model/user_model.dart';

abstract class RecoverPassDatasource {
  Future<UserModel> sendVerifyCode(
      {required String email, required String code});
  Future<String> sendEmailVerify({required String email});
  Future<String> updatePassword(
      {required String newPassword, required String authToken});
}
