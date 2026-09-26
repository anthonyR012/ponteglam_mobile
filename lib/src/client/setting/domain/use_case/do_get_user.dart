import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoGetUser {
  final SharedPreferences _prefs;

  DoGetUser(this._prefs);

  static const _userKey = 'cached_user';

  Future<Either<Failure, UserModel>> call() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson == null) {
        return Left(UnknownFailure('No user found'));
      }
      final user = UserModel.fromJson(jsonDecode(userJson));
      return Right(user);
    } catch (e) {
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
