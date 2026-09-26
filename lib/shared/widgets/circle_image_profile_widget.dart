import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';
import 'package:ponte_glam/device/camera/take_photo_gallery.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class CircleImageProfile extends StatefulWidget {
  const CircleImageProfile(
      {super.key,
      required this.size,
      this.allowTakePhoto = false,
      this.imageMain,
      this.subImage,
      this.colorBottomIcon = secondaryColorTheme,
      this.customBottomIcon,
      this.maxSize = 120,
      this.typeSourceImage = TypeSourceImage.asset,
      this.backgroundBottonIcon,
      this.gradient,
      this.colorCenterIcon,
      this.border,
      this.showSubIcon = true});

  final double size;
  final double maxSize;
  final bool allowTakePhoto;
  final String? imageMain;
  final String? subImage;
  final Color colorBottomIcon;
  final Color? backgroundBottonIcon;
  final TypeSourceImage typeSourceImage;
  final bool showSubIcon;
  final Gradient? gradient;
  final Color? colorCenterIcon;
  final Widget? customBottomIcon;
  final BoxBorder? border;

  @override
  State<CircleImageProfile> createState() => _CircleImageProfileState();
}

class _CircleImageProfileState extends State<CircleImageProfile> {
  final AlertManageUtil _alertManage = getIt<AlertManageUtil>();
  String? _image;
  Color? colorCenterIcon;
  late TypeSourceImage typeSourceImage;

  @override
  void initState() {
    typeSourceImage = widget.typeSourceImage;
    colorCenterIcon = widget.colorCenterIcon;
    _image = widget.imageMain;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircleImageProfile oldWidget) {
    if (oldWidget.imageMain != widget.imageMain ||
        oldWidget.typeSourceImage != widget.typeSourceImage) {
      setState(() {
        _image = widget.imageMain;
        typeSourceImage = widget.typeSourceImage;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  bool get _hasNoImage =>
      _image == null && getIt<NetworkState>().status != ConnectivityResult.none;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.allowTakePhoto ? _takePhoto : null,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            Positioned.fill(
              child: _hasNoImage
                  ? _GlamDefaultAvatar(
                      size: widget.size,
                      border: widget.border,
                      gradient: widget.gradient,
                    )
                  : Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: widget.border ??
                              Border.all(
                                width: 1,
                                color: whiteColorTheme,
                              ),
                          image: colorCenterIcon != null
                              ? DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      colorCenterIcon!, BlendMode.srcIn),
                                  image: _getImageType(),
                                  fit: BoxFit.contain)
                              : DecorationImage(
                                  image: _getImageType(), fit: BoxFit.fill)),
                    ),
            ),
            Visibility(
              visible: widget.showSubIcon,
              child: Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: widget.size * 0.15,
                  backgroundColor: widget.backgroundBottonIcon,
                  child: widget.customBottomIcon ??
                      SvgPicture.asset(
                        alignment: Alignment.center,
                        widget.subImage ?? "$pathManagementIcons$iconCamera",
                        semanticsLabel: iconCamera,
                        colorFilter: ColorFilter.mode(
                            widget.colorBottomIcon, BlendMode.srcIn),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageType() {
    if (getIt<NetworkState>().status == ConnectivityResult.none) {
      return const AssetImage('$pathManagementImages$imageNoWifi');
    }
    if (_image == null || _image!.isEmpty) {
      return const AssetImage("$pathManagementImages$imageUserOut");
    }

    if (typeSourceImage == TypeSourceImage.file) {
      return FileImage(File(_image!));
    }

    if (typeSourceImage == TypeSourceImage.asset) {
      return AssetImage(_image!);
    }

    final resolved = ImageUrlHelper.resolve(_image!);
    if (resolved != null && resolved.startsWith('http')) {
      return NetworkImage(resolved);
    }

    return const AssetImage("$pathManagementImages$imageUserOut");
  }

  void _takePhoto() async {
    try {
      _alertManage.show(type: OverlayAlertType.load);
      _image = await getImagePicker();
      getIt<SignUpCubit>().imageUpload = _image;
      typeSourceImage = TypeSourceImage.file;
      colorCenterIcon = null;
      setState(() {});
      await Future.delayed(Durations.short1);
      _alertManage.hide(type: OverlayAlertType.load);
    } catch (e, stackTrace) {
      _alertManage.hide(type: OverlayAlertType.load);
      catchError(e.toString(), stackTrace.toString());
    }
  }
}

class _GlamDefaultAvatar extends StatelessWidget {
  const _GlamDefaultAvatar({
    required this.size,
    this.border,
    this.gradient,
  });

  final double size;
  final BoxBorder? border;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient ?? glamGradientTheme,
        border: border ??
            Border.all(
              width: 1.5,
              color: whiteColorTheme,
            ),
      ),
      child: Center(
        child: SvgPicture.asset(
          '$pathManagementIcons$iconProfile',
          colorFilter: const ColorFilter.mode(
            whiteColorTheme,
            BlendMode.srcIn,
          ),
          width: size * 0.5,
          height: size * 0.5,
        ),
      ),
    );
  }
}
