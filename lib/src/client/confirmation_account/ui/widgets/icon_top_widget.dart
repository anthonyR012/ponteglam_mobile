import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/shared/widgets/icon_center_animation_widget.dart';

class IconTopPhoneConfirmation extends StatelessWidget {
  const IconTopPhoneConfirmation(
      {super.key,
      required this.width,
      required this.height,
      required this.sizeScreen,
      required this.image});
  final double width;
  final double height;
  final TypeSizeScreenDevice sizeScreen;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IconCenterAnimationSplash(
        size: width * 0.5,
      ),
    );
  }
}
