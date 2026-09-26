import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/image_load_widget.dart';

class UnavailableWidget extends StatelessWidget {
  const UnavailableWidget(
      {super.key,
      this.retryTap,
      this.image = imageUnavailable,
      this.textButton,
      required this.textDescription,
      required this.context});
  final String image;
  final String textDescription;
  final String? textButton;
  final BuildContext context;
  final void Function()? retryTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageLoadWidget(image: image, height: heigth * .1, width: width * .7),
        Text(
          textDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: fontFamilyMontserrat,
            fontSize: h4Size,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spaceBetween10),
        Visibility(
          visible: retryTap != null,
          child: InkWell(
            onTap: retryTap,
            child: Container(
              width: width * 0.6,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: glamGradientTheme),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textButton ?? getIt<AppLocalizations>().titleRetry,
                      style: const TextStyle(
                        color: whiteColorTheme,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Icon(
                      Icons.refresh,
                      color: whiteColorTheme,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
