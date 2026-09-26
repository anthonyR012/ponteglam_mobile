import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/sign_in/data/datasource/sign_in_datasource.dart';

class SignInLocalDatasourceImplement extends SingInLocalDatasource {
  SignInLocalDatasourceImplement(this._prefs);
  final SharedPreferences _prefs;

  static const _userKey = 'cached_user';

  @override
  Future<UserModel> saveUser({required UserModel user}) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
    return user;
  }

  @override
  Future<bool> signOut() async {
    await _prefs.remove(_userKey);
    return true;
  }
}
