import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageLoadWidget extends StatelessWidget {
  const ImageLoadWidget(
      {super.key,
      this.typeSourceImage = TypeSourceImage.asset,
      this.fit = BoxFit.contain,
      this.isLoading = false,
      this.bytesImage,
      this.width,
      this.height,
      required this.image});
  final TypeSourceImage typeSourceImage;
  final String? image;
  final Uint8List? bytesImage;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (image == null && bytesImage == null) {
      return _getErrorWidget();
    }
    Widget child =
        isLoading ? SizedBox(width: width, height: height) : _getImageChild();
    return Skeleton.leaf(enabled: isLoading, child: child);
  }

  Widget _getErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: greyBlockColorTheme.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.wifi_off_rounded,
          color: grayTextColorTheme.withValues(alpha: 0.4),
          size: (width != null && height != null)
              ? (width! < height! ? width! : height!) * 0.3
              : 24,
        ),
      ),
    );
  }

  Widget _getImageChild() {
    if (image != null && image!.startsWith('http')) {
      final resolved = ImageUrlHelper.resolve(image!) ?? image!;
      return Image.network(
        resolved,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress != null
              ? SvgPicture.asset('$pathManagementIcons$iconPonteNegative',
                  colorFilter: ColorFilter.mode(
                      blackColorTheme.withValues(alpha: 0.5), BlendMode.srcIn),
                  width: (width ?? 50) * .2,
                  height: (height ?? 50) * .2)
              : child;
        },
      );
    }

    if (typeSourceImage == TypeSourceImage.asset) {
      return Image.asset(
        '$pathManagementImages$image',
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getErrorWidget();
        },
      );
    } else if (typeSourceImage == TypeSourceImage.file) {
      return Image.file(
        File(image!),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getErrorWidget();
        },
      );
    } else if (typeSourceImage == TypeSourceImage.network) {
      final resolved = ImageUrlHelper.resolve(image!) ?? image!;
      return Image.network(
        resolved,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress != null
              ? SvgPicture.asset('$pathManagementIcons$iconPonteNegative',
                  colorFilter: ColorFilter.mode(
                      blackColorTheme.withValues(alpha: 0.5), BlendMode.srcIn),
                  width: (width ?? 50) * .2,
                  height: (height ?? 50) * .2)
              : child;
        },
      );
    } else {
      return Image.memory(
        bytesImage!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getErrorWidget();
        },
      );
    }
  }
}
