import 'package:ponte_glam/shared/model/user_model.dart';

abstract class SignUpDatasource {
  Future<UserModel> signUp({required UserModel user});
}
