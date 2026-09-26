import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ponte_glam/src/shared/core/log/domain/use_case/create_mobile_log.dart';

class MobileLogInterceptor extends Interceptor {
  final CreateMobileLog createMobileLog;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  MobileLogInterceptor(this.createMobileLog);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode != null && response.statusCode! >= 400) {
      await _logError(
        "HTTP Error ${response.statusCode}: ${response.statusMessage} | URL: ${response.requestOptions.path} | Method: ${response.requestOptions.method} | Data: ${response.data}",
        "MobileLogInterceptor:onResponse",
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Skip logging if the error comes from the logging endpoint itself to avoid infinite loops
    if (err.requestOptions.path.contains('create-mobile-app-log')) {
      return super.onError(err, handler);
    }

    try {
      await _logError(
        "API Error: ${err.message} | URL: ${err.requestOptions.path} | Method: ${err.requestOptions.method} | Status: ${err.response?.statusCode} | Data: ${err.response?.data}",
        "MobileLogInterceptor:onError",
      );
    } catch (e) {
      // Avoid crashing if logging fails
    }

    super.onError(err, handler);
  }

  Future<void> _logError(String description, String source) async {
    try {
      await createMobileLog(
        description: description,
        source: source,
      );
    } catch (e) {
      // Silent fail to avoid app crash
    }
  }
}
