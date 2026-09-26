import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ponte_glam/config/routers/router.dart';
import 'package:ponte_glam/core/navigation/notification_navigator.dart';
import 'package:ponte_glam/src/client/appointment/ui/appointment_detail_page.dart';
import 'package:ponte_glam/src/client/history/ui/history_page.dart';

const String _channelId = 'ponteglam_high_importance';
const String _channelName = 'PonteGlam Notificaciones';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  // Initializa one time (main isolate)
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Crear el canal de alta importancia requerido por Android 8+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show notification — can be called from the background isolate

  static Future<void> showFromRemoteMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Serialize the message data as a payload
    final String? payloadJson =
        message.data.isNotEmpty ? jsonEncode(message.data) : null;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: payloadJson,
    );
  }

  /// Handler called when the user taps a local notification
  static void _onNotificationTap(NotificationResponse response) {
    final String? payloadStr = response.payload;
    if (payloadStr == null || payloadStr.isEmpty) return;

    final Map<String, dynamic> data =
        jsonDecode(payloadStr) as Map<String, dynamic>;

    _navigateFromData(data);
  }

  /// Processes the FCM payload y call [NotificationNavigator.navigate].
  static void navigateFromPayload(String payloadJson) {
    final Map<String, dynamic> data =
        jsonDecode(payloadJson) as Map<String, dynamic>;
    _navigateFromData(data);
  }

  static void _navigateFromData(Map<String, dynamic> data) {
    final action = data['action'] as String?;
    final appointmentIdStr = data['appointment_id'] as String?;
    final promptRating = data['prompt_rating'] == 'true';

    if (action == null) return;

    if ((action == 'history' || action == 'supplier_appointments') &&
        appointmentIdStr != null) {
      final appointmentId = int.tryParse(appointmentIdStr);
      if (appointmentId == null) return;

      NotificationNavigator.navigate(
        router,
        '/${AppointmentHistory.routeName}/${AppointmentDetailPage.routeName}',
        extra: {
          'appointmentId': appointmentId,
          'autoOpenRating': promptRating,
        },
      );
    }
  }
}
