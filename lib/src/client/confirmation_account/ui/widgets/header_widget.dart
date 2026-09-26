import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class HeaderPhoneConfirmation extends StatelessWidget {
  const HeaderPhoneConfirmation(
      {super.key,
      required this.sizeScreen,
      required this.width,
      required this.namePerson,
      required this.email,
      this.showSubIcon = false,
      this.imagePath});
  final TypeSizeScreenDevice sizeScreen;
  final double width;
  final String namePerson;
  final String email;
  final bool showSubIcon;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (sizeScreen == TypeSizeScreenDevice.bigMobile) {
      return Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width / 2,
                child: Text(
                  namePerson,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.bold,
                      color: whiteColorTheme,
                      fontSize: h3Size),
                ),
              ),
              SizedBox(
                width: width / 2,
                child: RichText(
                  maxLines: maxLinesSize + 2,
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      TextSpan(
                          text: getIt<AppLocalizations>()
                              .sentenceConfirmYourEmail,
                          style: const TextStyle(
                              fontFamily: fontFamilyLora,
                              color: whiteColorTheme,
                              fontSize: bodySize)),
                      TextSpan(
                        text: "\n$email",
                        style: const TextStyle(
                            fontFamily: fontFamilyMontserrat,
                            color: secondaryColorTheme,
                            fontSize: minimalMonserratSize),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleImageProfile(
              size: width * 0.1,
              showSubIcon: showSubIcon,
              typeSourceImage: TypeSourceImage.network,
              imageMain: imagePath)
        ],
      );
    } else if (sizeScreen == TypeSizeScreenDevice.extraBigMobile) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            width: width / 2,
            child: Text(
              namePerson,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  color: whiteColorTheme,
                  fontSize: h3Size),
            ),
          ),
          SizedBox(
            width: width / 2,
            child: RichText(
              maxLines: maxLinesSize + 2,
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  TextSpan(
                      text: getIt<AppLocalizations>().sentenceConfirmYourEmail,
                      style: const TextStyle(
                          fontFamily: fontFamilyLora,
                          color: whiteColorTheme,
                          fontSize: bodySize)),
                  TextSpan(
                    text: "\n$email",
                    style: const TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        color: secondaryColorTheme,
                        fontSize: minimalMonserratSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                    ? width / 2.5
                    : width / 2,
                child: Text(
                  namePerson,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLinesSize,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.bold,
                      color: whiteColorTheme,
                      fontSize:
                          sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                              ? h5Size
                              : h4Size),
                ),
              ),
              SizedBox(
                width: width / 2,
                child: RichText(
                  maxLines: maxLinesSize + 2,
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      TextSpan(
                          text: getIt<AppLocalizations>()
                              .sentenceConfirmYourEmail,
                          style: const TextStyle(
                              fontFamily: fontFamilyLora,
                              color: whiteColorTheme,
                              fontSize: bodySize)),
                      TextSpan(
                        text: "\n$email",
                        style: const TextStyle(
                            fontFamily: fontFamilyMontserrat,
                            color: secondaryColorTheme,
                            fontSize: minimalMonserratSize),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleImageProfile(
              size: sizeScreen == TypeSizeScreenDevice.extraSmallMobile
                  ? width * 0.1
                  : width * 0.15,
              showSubIcon: showSubIcon,
              typeSourceImage: TypeSourceImage.network,
              imageMain: imagePath)
        ],
      );
    }
  }
}
