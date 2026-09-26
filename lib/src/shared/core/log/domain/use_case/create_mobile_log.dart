import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ponte_glam/src/shared/core/log/domain/model/mobile_log_model.dart';
import 'package:ponte_glam/src/shared/core/log/domain/repository/log_repository.dart';

class CreateMobileLog {
  final LogRepository _repository;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  CreateMobileLog(this._repository);

  Future<void> call({required String description, required String source}) async {
    String deviceInfo = await _getDeviceInfo();
    final log = MobileLogModel(
      deviceInfo: deviceInfo,
      description: description,
      source: source,
    );
    return await _repository.createMobileLogs([log]);
  }

  Future<String> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return "Android ${androidInfo.version.release}, ${androidInfo.manufacturer} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return "iOS ${iosInfo.systemVersion}, ${iosInfo.name} ${iosInfo.model}";
      }
    } catch (e) {
      return "Unknown Device";
    }
    return "Unknown Device";
  }
}
