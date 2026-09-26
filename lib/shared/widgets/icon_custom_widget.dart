import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';

class IconCustomWidget extends StatelessWidget {
  const IconCustomWidget(
      {super.key,
      required this.icon,
      required this.colorFilter,
      this.fit,
      this.width = 20,
      this.height = 20});
  final String icon;
  final ColorFilter colorFilter;
  final double width;
  final double height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$pathManagementIcons$icon',
      semanticsLabel: iconPonteSecondary,
      colorFilter: colorFilter,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}
