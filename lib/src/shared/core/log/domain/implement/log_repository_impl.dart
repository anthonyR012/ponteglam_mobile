import 'package:ponte_glam/src/shared/core/log/data/datasource/log_datasource.dart';
import 'package:ponte_glam/src/shared/core/log/domain/model/mobile_log_model.dart';
import 'package:ponte_glam/src/shared/core/log/domain/repository/log_repository.dart';

class LogRepositoryImpl implements LogRepository {
  final LogDatasource _datasource;

  LogRepositoryImpl(this._datasource);

  @override
  Future<void> createMobileLogs(List<MobileLogModel> logs) async {
    return await _datasource.createMobileLogs(logs);
  }
}
