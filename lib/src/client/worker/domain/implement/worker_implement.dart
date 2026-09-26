import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/worker_model.dart';
import 'package:ponte_glam/src/client/worker/data/datasource/worker_datasource.dart';

abstract class WorkerRepository {
  Future<Either<Failure, List<WorkerModel>>> getWorkers(
      {required String authToken, int? headQuarterId, int? serviceId});
}

class WorkerImplement extends WorkerRepository {
  WorkerImplement(this._workerApiDatasource);
  final WorkerApiDatasource _workerApiDatasource;

  @override
  Future<Either<Failure, List<WorkerModel>>> getWorkers(
      {required String authToken, int? headQuarterId, int? serviceId}) async {
    try {
      final response = await _workerApiDatasource.getWorkers(
          authToken: authToken,
          headQuarterId: headQuarterId,
          serviceId: serviceId);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
