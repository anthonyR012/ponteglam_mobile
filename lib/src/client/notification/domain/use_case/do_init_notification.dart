import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DoInitNotification {
  final NotificationRepository notificationRepository;
  DoInitNotification(this.notificationRepository);

  Future<Either<Failure, String>> call() async {
    final state = await notificationRepository.initNotifications();
    return state;
  }
}
