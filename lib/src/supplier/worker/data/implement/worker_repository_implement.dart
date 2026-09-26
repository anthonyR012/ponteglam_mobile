import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/supplier/worker/data/datasource/worker_datasource.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/worker_block_model.dart';
import 'package:ponte_glam/src/supplier/worker/domain/repository/worker_repository.dart';

class WorkerRepositoryImplement implements WorkerRepository {
  final WorkerDatasource _datasource;
  final IStorage _storage;

  WorkerRepositoryImplement(this._datasource, this._storage);

  Future<String> get _token async => await _storage.read(key: keyAuthToken) ?? '';

  @override
  Future<List<StaffMemberModel>> getStaff(int headquarterId) async {
    return _datasource.getStaff(authToken: await _token, headquarterId: headquarterId);
  }

  @override
  Future<void> onboardWorker({
    required int headquarterId,
    required bool isAnonymous,
    String? name,
    String? email,
    String? phone,
  }) async {
    return _datasource.onboardWorker(
      authToken: await _token,
      headquarterId: headquarterId,
      isAnonymous: isAnonymous,
      name: name,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<void> linkService(int workerId, int serviceId) async {
    return _datasource.linkService(authToken: await _token, workerId: workerId, serviceId: serviceId);
  }

  @override
  Future<String?> unlinkService(int workerId, int serviceId) async {
    return _datasource.unlinkService(authToken: await _token, workerId: workerId, serviceId: serviceId);
  }

  @override
  Future<void> addBlock(int workerId, WorkerBlockModel block) async {
    return _datasource.addBlock(authToken: await _token, workerId: workerId, block: block);
  }

  @override
  Future<void> removeFromHq(int workerId, int headquarterId) async {
    return _datasource.removeFromHq(authToken: await _token, workerId: workerId, headquarterId: headquarterId);
  }
}
