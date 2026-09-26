import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class ButtonTopWidget extends StatelessWidget {
  const ButtonTopWidget(
      {super.key,
      this.icon,
      this.child,
      this.topPadding = 0,
      this.isPositioned = true,
      this.colorBackground = Colors.black12,
      this.rigth,
      this.left,
      this.boxShadow,
      this.sizeIcon = 33,
      this.onTap});

  final double topPadding;
  final String? icon;
  final Widget? child;
  final double? rigth;
  final double? left;
  final bool isPositioned;
  final List<BoxShadow>? boxShadow;
  final Color colorBackground;
  final void Function()? onTap;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    assert(child != null || icon != null, "Must provide a child or an icon");
    final Widget iconWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: icon != null
          ? ButtonLabelShadow(
              onTap: onTap,
              colorBackground: colorBackground,
              boxShadow: boxShadow,
              sizeIcon: sizeIcon,
              icon: icon!)
          : child,
    );
    return isPositioned
        ? Positioned(
            top: topPadding + 10, left: left, right: rigth, child: iconWidget)
        : iconWidget;
  }
}

class ButtonLabelShadow extends StatelessWidget {
  const ButtonLabelShadow({
    super.key,
    this.onTap,
    required this.colorBackground,
    this.boxShadow,
    required this.icon,
    this.sizeIcon = 33,
  });

  final void Function()? onTap;
  final Color colorBackground;
  final List<BoxShadow>? boxShadow;
  final String icon;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: primaryColorTheme,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: sizeIcon + 2,
        height: sizeIcon,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorBackground,
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]),
        child: SvgPicture.asset(
          '$pathManagementIcons$icon',
          colorFilter: const ColorFilter.mode(whiteColorTheme, BlendMode.srcIn),
        ),
      ),
    );
  }
}
