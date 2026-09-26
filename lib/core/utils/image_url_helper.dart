import 'package:get_it/get_it.dart';
import 'package:ponte_glam/config/constant/end_point_constant.dart';

class ImageUrlHelper {
  ImageUrlHelper._();

  static String? resolve(String? url) {
    if (url == null || url.isEmpty) return null;

    final baseUrl = GetIt.instance<EndPoints>().baseUrl;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      final uri = Uri.tryParse(url);
      if (uri == null) return url;

      final baseUri = Uri.tryParse(baseUrl);
      if (baseUri == null) return url;

      if (uri.host == baseUri.host && uri.port == baseUri.port) {
        return url;
      }

      return '$baseUrl${uri.path}';
    }

    if (url.startsWith('/media/') || url.startsWith('/')) {
      return '$baseUrl$url';
    }

    if (url.startsWith('media/')) {
      return '$baseUrl/$url';
    }

    return url;
  }
}
