
import 'package:ponte_glam/di/shared_imports.dart';

class NotificationFirebaseDatasourceImplement
    implements NotificationFirebaseDatasource {
  final FirebaseMessaging _firebaseMessaging;
  final FailureManage _failureManage;
  final FirebaseApiMessaging _firebaseCloudMessaging;
  NotificationFirebaseDatasourceImplement(this._firebaseMessaging,
      this._failureManage, this._firebaseCloudMessaging);

  @override
  Future<String> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    String token = await _firebaseMessaging.getToken() ?? "";
    throwIfError(token.isEmpty, _failureManage.noFound("client token"));
    _firebaseCloudMessaging.onListenMessage();
    _firebaseCloudMessaging.onDeepLinkFromNotification();
    return token;
  }
}
