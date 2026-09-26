import 'package:ponte_glam/shared/model/notification_model.dart';

abstract class NotificationDatasource {}

mixin InitNotificationsMixin {
  Future<String> initNotifications();
}

mixin GetNotificationMixin {
  Future<NotificationListModel> getNotifications(
      {required String authToken, String? nextUrl, int? companyId});
}

mixin RegisterDeviceMixin {
  Future<void> registerDevice({
    required String authToken,
    required String registrationId,
    required String deviceType,
  });
}

mixin GetUnreadCountMixin {
  Future<int> getUnreadCount({required String authToken, int? companyId});
}

abstract class NotificationFirebaseDatasource extends NotificationDatasource
    with InitNotificationsMixin {}

abstract class NotificationApiDatasource extends NotificationDatasource
    with GetNotificationMixin, RegisterDeviceMixin, GetUnreadCountMixin {}
