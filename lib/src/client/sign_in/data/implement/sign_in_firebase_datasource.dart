import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/connectivity/network_state.dart';
import 'package:ponte_glam/src/client/sign_in/data/datasource/sign_in_datasource.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class SignInFirebaseDatasourceImplement extends SingInFirebaseDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSingIn;
  final NetworkState _network;
  final FailureManage _failureManage;

  SignInFirebaseDatasourceImplement(
      this._auth, this._googleSingIn, this._network, this._failureManage);

  @override
  Future<UserModel> signIn({String? username, String? password}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSingIn.signIn();
    if (googleSignInAccount == null) {
      throw _failureManage.client("Retry again");
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    // Getting users credential
    UserCredential result = await _auth.signInWithCredential(authCredential);
    if (result.user == null) {
      throw _failureManage.emptyField;
    }
    User user = result.user!;
    UserModel userEntiti = UserModel(
        password: user.uid,
        googleAccessToken: googleSignInAuthentication.accessToken,
        username: user.email,
        uuidGoogle: user.uid,
        email: user.email,
        fullName: user.displayName,
        phone: user.phoneNumber,
        picture: user.photoURL,
        emailVerified: true,
        token: null,
        id: null);
    return userEntiti;
  }

  @override
  Future<bool> signOut() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    bool result = await _googleSingIn.isSignedIn();
    if (result) {
      await _auth.signOut();
      await _googleSingIn.signOut();
    }
    return result;
  }
}
