import 'package:ponte_glam/src/shared/core/log/domain/model/mobile_log_model.dart';

abstract class LogRepository {
  Future<void> createMobileLogs(List<MobileLogModel> logs);
}
