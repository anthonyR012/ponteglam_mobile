import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/sign_in/data/datasource/sign_in_datasource.dart';
import 'package:ponte_glam/src/client/sign_in/domain/repository/sign_in_repository.dart';

class SignInImplement extends SignInRepository {
  final SingInApiDatasource _signInApiDatasource;
  final SingInLocalDatasource _signInLocalDatasource;
  final SingInFirebaseDatasource _signInFirebaseDatasource;
  final IStorage _storage;
  final FirebaseMessaging _firebaseMessaging;

  SignInImplement(
    this._signInApiDatasource,
    this._signInLocalDatasource,
    this._signInFirebaseDatasource,
    this._storage,
    this._firebaseMessaging,
  );

  @override
  Future<Either<Failure, UserModel>> signIn(
      {String? userName,
      String? password,
      required Repository datasource}) async {
    try {
      UserModel? user;
      if (datasource == Repository.api) {
        user = await _signInApiDatasource.signIn(
            password: password, username: userName);
      } else if (datasource == Repository.firebase) {
        user = await _signInFirebaseDatasource.signIn(
            password: password, username: userName);
      }
      if (user == null) {
        throw UnimplementedError();
      }
      return Right(user);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut(
      {required Repository datasource}) async {
    try {
      bool value = false;
      if (datasource == Repository.firebase) {
        value = await _signInFirebaseDatasource.signOut();
      } else if (datasource == Repository.local) {
        value = await _signInLocalDatasource.signOut();
      }
      return Right(value);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> saveUser(
      {required UserModel user, required Repository datasource}) async {
    try {
      UserModel? userValue;
      if (datasource == Repository.local) {
        userValue = await _signInLocalDatasource.saveUser(user: user);
      } else if (datasource == Repository.api) {
        userValue = await _signInApiDatasource.saveUser(user: user);
      }
      if (userValue == null) throw UnimplementedError();
      return Right(userValue);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerFcmToken(
      {required String authToken}) async {
    try {
      await _signInApiDatasource.registerFcmToken(authToken: authToken);
      final String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _storage.write(key: keyFcmToken, value: fcmToken);
      }
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFcmToken({
    required String authToken,
    required String fcmToken,
  }) async {
    try {
      await _signInApiDatasource.deleteFcmToken(
          authToken: authToken, fcmToken: fcmToken);
      try {
        await _firebaseMessaging.deleteToken();
      } catch (e, stackTrace) {
        catchError(e.toString(), stackTrace.toString());
      }
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
