import 'package:ponte_glam/shared/model/worker_model.dart';

abstract class WorkerApiDatasource {
  Future<List<WorkerModel>> getWorkers(
      {required String authToken, int? headQuarterId, int? serviceId});
}
