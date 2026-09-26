import 'package:ponte_glam/shared/model/user_model.dart';

abstract class SignInDatasource {}

mixin SignInMixin {
  Future<UserModel> signIn({String? username, String? password});
}

mixin SaveUserMixin {
  Future<UserModel> saveUser({required UserModel user});
}

mixin SignoutMixin {
  Future<bool> signOut();
}

abstract class SingInLocalDatasource
    implements SignInDatasource, SaveUserMixin, SignoutMixin {}

mixin FcmTokenMixin {
  Future<void> registerFcmToken({required String authToken});
  Future<void> deleteFcmToken({
    required String authToken,
    required String fcmToken,
  });
}

abstract class SingInApiDatasource
    implements SignInDatasource, SignInMixin, SaveUserMixin, FcmTokenMixin {}

abstract class SingInFirebaseDatasource
    implements SignInDatasource, SignInMixin, SignoutMixin {}
