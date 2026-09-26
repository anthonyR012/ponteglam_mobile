import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, String>> initNotifications();
  Future<Either<Failure, NotificationListModel>> getNotifications(
      {required String authToken, String? nextUrl, int? companyId});
  Future<Either<Failure, void>> registerDevice({
    required String authToken,
    required String registrationId,
    required String deviceType,
  });
  Future<Either<Failure, int>> getUnreadCount({required String authToken, int? companyId});
}
