import 'package:ponte_glam/config/routers/router.dart';
import 'package:ponte_glam/core/navigation/notification_navigator.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/main.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/appointment/ui/appointment_detail_page.dart';
import 'package:ponte_glam/src/client/history/ui/history_page.dart';
import 'package:ponte_glam/core/utils/sound_utils.dart';

abstract class FirebaseApiMessaging {
  void onBackgroundMessage();
  void onListenMessage();
  void onDeepLinkFromNotification();
  void showNotification(Map<String, dynamic> message);
}

class FirebaseCloudMessaging implements FirebaseApiMessaging {
  final AlertManageUtil _alertManage;
  final AlertManageCubit _alertManageCubit;

  bool _listenersInitialized = false;

  FirebaseCloudMessaging(this._alertManage, this._alertManageCubit);

  @override
  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  @override
  void onListenMessage() {
    if (_listenersInitialized) return;
    _listenersInitialized = true;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      try {
        getIt<HomeBloc>().add(const DoGetUnreadCountEvent());
      } catch (_) {}

      SoundUtil.playNotificationSound();
      _alertManageCubit.snackParamaters = ParameterSnackBarCustom(
          message: notification.title ?? '', typeAlert: TypeAlert.notification);
      _alertManage.showFor(seconds: 3, type: OverlayAlertType.snackbar);
    });
  }

  @override
  void onDeepLinkFromNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final action = data['action'] as String?;
    final appointmentIdStr = data['appointment_id'] as String?;
    final promptRating = data['prompt_rating'] == 'true';

    if (action == null) return;

    final context = router.routerDelegate.navigatorKey.currentContext;
    if (context == null) return;

    if (action == 'history' && appointmentIdStr != null) {
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
    } else if (action == 'supplier_appointments' && appointmentIdStr != null) {
      final appointmentId = int.tryParse(appointmentIdStr);
      if (appointmentId == null) return;

      NotificationNavigator.navigate(
        router,
        '/${AppointmentHistory.routeName}/${AppointmentDetailPage.routeName}',
        extra: {'appointmentId': appointmentId, 'autoOpenRating': false},
      );
    }
  }

  @override
  void showNotification(Map<String, dynamic> message) {}
}
