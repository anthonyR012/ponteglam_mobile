import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';

class DoGetNotifications {
  final NotificationRepository notificationRepository;
  DoGetNotifications(this.notificationRepository);

  Future<Either<Failure, NotificationListModel>> call(
      {required IStorage storage, String? nextUrl, int? companyId}) async {
    final authToken = await storage.read(key: keyAuthToken) ?? "";
    final state = await notificationRepository.getNotifications(
        authToken: authToken, nextUrl: nextUrl, companyId: companyId);
    return state;
  }
}
