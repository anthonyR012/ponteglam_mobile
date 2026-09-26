import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/worker_model.dart';
import 'package:ponte_glam/src/client/worker/domain/implement/worker_implement.dart';
import 'package:ponte_glam/device/storage/istorage.dart';

class DoGetWorkers {
  DoGetWorkers(this._repository);
  final WorkerRepository _repository;

  Future<Either<Failure, List<WorkerModel>>> call({int? headQuarterId, int? serviceId}) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? "";
    return await _repository.getWorkers(
        authToken: authToken,
        headQuarterId: headQuarterId,
        serviceId: serviceId);
  }
}
