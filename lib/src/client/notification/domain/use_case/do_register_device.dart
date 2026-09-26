import 'dart:io';
import 'package:ponte_glam/di/shared_imports.dart';

class DoRegisterDevice {
  final NotificationRepository _repository;
  DoRegisterDevice(this._repository);

  /// Obtiene el token FCM actual y registra el dispositivo en el backend.
  /// Es fire-and-forget: los errores se silencian para no interrumpir el flujo.
  Future<void> call() async {
    try {
      final IStorage storage = getIt<IStorage>();
      final String authToken = await storage.read(key: keyAuthToken) ?? '';
      if (authToken.isEmpty) return;

      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      String deviceType = 'web';
      if (Platform.isAndroid) {
        deviceType = 'android';
      } else if (Platform.isIOS) {
        deviceType = 'ios';
      }

      await _repository.registerDevice(
        authToken: authToken,
        registrationId: fcmToken,
        deviceType: deviceType,
      );
    } catch (_) {
      // fire-and-forget
    }
  }
}
