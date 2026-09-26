import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LabelContentWidget extends StatelessWidget {
  const LabelContentWidget(
      {super.key,
      required this.icon,
      required this.description,
      this.isLoading = false,
      this.colorIcon,
      this.colorDescription,
      this.colorBackground,
      this.sizeIcon = 17,
      this.fontSize = minimalMonserratSize});
  final String icon;
  final String description;
  final Color? colorIcon;
  final Color? colorDescription;
  final Color? colorBackground;
  final double sizeIcon;
  final double fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(rounded28)),
          color: colorBackground ?? linearColorTheme.withValues(alpha: 0.1),
        ),
        child: Row(
          children: [
            Skeleton.shade(
              shade: isLoading,
              child: SvgPicture.asset(
                '$pathManagementIcons$icon',
                colorFilter: ColorFilter.mode(
                    colorIcon ?? secondaryColorTheme, BlendMode.srcIn),
                width: sizeIcon,
                height: sizeIcon,
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Skeleton.leaf(
              enabled: isLoading,
              child: Text(
                description,
                style: TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    color: colorDescription ?? blackColorTheme,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize),
              ),
            )
          ],
        ));
  }
}
