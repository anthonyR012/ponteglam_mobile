import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class HeaderAdditionalInformation extends StatelessWidget {
  const HeaderAdditionalInformation(
      {super.key, required this.sizeScreen, required this.width});
  final TypeSizeScreenDevice sizeScreen;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (sizeScreen == TypeSizeScreenDevice.bigMobile) {
      return Row(
        children: [
          SizedBox(
            width: width / 2,
            child: Text(
              getIt<AppLocalizations>().titleLetUsKnowYou,
              style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  color: whiteColorTheme,
                  fontSize: h3Size),
            ),
          ),
          const Spacer(),
          CircleImageProfile(size: width * 0.1)
        ],
      );
    } else if (sizeScreen == TypeSizeScreenDevice.extraBigMobile) {
      return SizedBox(
        height: 60,
        width: width / 2,
        child: Text(
          getIt<AppLocalizations>().titleLetUsKnowYou,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
              color: whiteColorTheme,
              fontSize: h3Size),
        ),
      );
    } else {
      return Row(
        children: [
          SizedBox(
            width: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                ? width / 2.5
                : width / 2,
            child: Text(
              getIt<AppLocalizations>().titleLetUsKnowYou,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLinesSize,
              style: TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  color: whiteColorTheme,
                  fontSize: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                      ? h5Size
                      : h4Size),
            ),
          ),
          const Spacer(),
          CircleImageProfile(
              size: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                  ? width * 0.1
                  : width * 0.15)
        ],
      );
    }
  }
}
