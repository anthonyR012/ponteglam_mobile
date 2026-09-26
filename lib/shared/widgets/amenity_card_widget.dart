import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AmenityCard extends StatelessWidget {
  const AmenityCard(
      {super.key,
      required this.width,
      required this.icon,
      required this.description,
      required this.isLoading});

  final double width;
  final String icon;
  final String description;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final double widthCard = width * .24;
    return Skeleton.shade(
      shade: isLoading,
      child: Container(
        width: widthCard,
        height: width * .24,
        margin: const EdgeInsets.all(paddingInput15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded10),
          color: linearColorTheme.withValues(alpha: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const Skeleton.leaf(child: CircleAvatar())
                : SvgPicture.asset(
                    '$pathManagementIcons$icon',
                    colorFilter: const ColorFilter.mode(
                        secondaryColorTheme, BlendMode.srcIn),
                    width: 28,
                    height: 28,
                  ),
            const SizedBox(width: spaceBetween10 + 5),
            SizedBox(
              width: widthCard * 0.8,
              child: Text(isLoading ? "_" * 4 : description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: secondaryColorTheme,
                    fontFamily: fontFamilyHind,
                    fontSize: h5Size + 2,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
