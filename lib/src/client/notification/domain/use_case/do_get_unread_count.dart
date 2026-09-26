import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/client/notification/domain/repository/notification_repository.dart';

class DoGetUnreadCount {
  final NotificationRepository _repository;
  DoGetUnreadCount(this._repository);

  Future<Either<Failure, int>> call({int? companyId}) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    return _repository.getUnreadCount(authToken: authToken, companyId: companyId);
  }
}
