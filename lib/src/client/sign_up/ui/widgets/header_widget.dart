import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class HeaderSingUpPersonalWidget extends StatelessWidget {
  const HeaderSingUpPersonalWidget({
    super.key,
    required this.width,
    this.sizeScreen = TypeSizeScreenDevice.mediumMobile,
  });
  final TypeSizeScreenDevice sizeScreen;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (sizeScreen == TypeSizeScreenDevice.bigMobile) {
      return Row(
        children: [
          Text(
            getIt<AppLocalizations>().titleSignUp,
            style: const TextStyle(
                fontFamily: fontFamilyMontserrat,
                fontWeight: FontWeight.bold,
                color: whiteColorTheme,
                fontSize: h2Size),
          ),
          const Spacer(),
          CircleImageProfile(
            typeSourceImage: TypeSourceImage.network,
            allowTakePhoto: true,
            size: width * 0.2,
          )
        ],
      );
    } else if (sizeScreen == TypeSizeScreenDevice.extraBigMobile) {
      return SizedBox(
        height: 60,
        width: width / 3.5,
        child: Text(
          getIt<AppLocalizations>().titleSignUp,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
              color: whiteColorTheme,
              fontSize: h2Size),
        ),
      );
    } else {
      return Row(
        children: [
          Text(
            getIt<AppLocalizations>().titleSignUp,
            style: TextStyle(
                fontFamily: fontFamilyMontserrat,
                fontWeight: FontWeight.bold,
                color: whiteColorTheme,
                fontSize: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                    ? h4Size
                    : h2Size),
          ),
          const Spacer(),
          CircleImageProfile(
              typeSourceImage: TypeSourceImage.network,
              allowTakePhoto: true,
              size: width * 0.2,
              colorCenterIcon: Colors.white)
        ],
      );
    }
  }
}
