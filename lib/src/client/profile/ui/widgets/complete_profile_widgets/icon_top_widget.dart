import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/shared/widgets/icon_center_animation_widget.dart';

class IconTopAdditionalInformation extends StatelessWidget {
  const IconTopAdditionalInformation(
      {super.key, required this.size, required this.sizeScreen});
  final double size;
  final TypeSizeScreenDevice sizeScreen;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IconCenterAnimationSplash(
        size: size,
      ),
    );
  }
}
