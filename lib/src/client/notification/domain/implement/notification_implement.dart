import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';

class NotificationImplement extends NotificationRepository {
  final NotificationFirebaseDatasource notificationFirebaseDatasource;
  final NotificationApiDatasource notificationApiDatasource;

  NotificationImplement(
      this.notificationFirebaseDatasource, this.notificationApiDatasource);

  @override
  Future<Either<Failure, String>> initNotifications() async {
    try {
      final String token =
          await notificationFirebaseDatasource.initNotifications();
      return Right(token);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationListModel>> getNotifications(
      {required String authToken, String? nextUrl, int? companyId}) async {
    try {
      final NotificationListModel notifications =
          await notificationApiDatasource.getNotifications(
              authToken: authToken, nextUrl: nextUrl, companyId: companyId);
      return Right(notifications);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerDevice({
    required String authToken,
    required String registrationId,
    required String deviceType,
  }) async {
    try {
      await notificationApiDatasource.registerDevice(
        authToken: authToken,
        registrationId: registrationId,
        deviceType: deviceType,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount(
      {required String authToken, int? companyId}) async {
    try {
      final int count =
          await notificationApiDatasource.getUnreadCount(
              authToken: authToken, companyId: companyId);
      return Right(count);
    } catch (e, stackTrace) {
      if (e is! Failure) catchError(e.toString(), stackTrace.toString());
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
