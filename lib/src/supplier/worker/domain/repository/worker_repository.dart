import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/worker_block_model.dart';

abstract class WorkerRepository {
  Future<List<StaffMemberModel>> getStaff(int headquarterId);
  Future<void> onboardWorker({
    required int headquarterId,
    required bool isAnonymous,
    String? name,
    String? email,
    String? phone,
  });
  Future<void> linkService(int workerId, int serviceId);
  Future<String?> unlinkService(int workerId, int serviceId);
  Future<void> addBlock(int workerId, WorkerBlockModel block);
  Future<void> removeFromHq(int workerId, int headquarterId);
}
