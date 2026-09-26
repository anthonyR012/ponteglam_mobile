import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/worker_block_model.dart';

abstract class WorkerDatasource {
  Future<List<StaffMemberModel>> getStaff({
    required String authToken,
    required int headquarterId,
  });

  Future<void> onboardWorker({
    required String authToken,
    required int headquarterId,
    required bool isAnonymous,
    String? name,
    String? email,
    String? phone,
  });

  Future<void> linkService({
    required String authToken,
    required int workerId,
    required int serviceId,
  });

  Future<String?> unlinkService({
    required String authToken,
    required int workerId,
    required int serviceId,
  });

  Future<void> addBlock({
    required String authToken,
    required int workerId,
    required WorkerBlockModel block,
  });

  Future<void> removeFromHq({
    required String authToken,
    required int workerId,
    required int headquarterId,
  });
}
