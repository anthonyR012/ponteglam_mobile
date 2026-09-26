import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/shared/widgets/image_load_widget.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({super.key, required this.animationController});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final introductionanimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: const Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: introductionanimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: spaceBetween10 * 5),
            SizedBox(
                width: width * .8,
                height: width * .7,
                child: const Hero(
                    tag: imagePonteGradient,
                    child: ImageLoadWidget(image: imagePonteGradient))),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                getIt<AppLocalizations>().app_title,
                style: const TextStyle(
                    fontSize: h1Size - 5,
                    fontWeight: FontWeight.bold,
                    color: primaryColorTheme),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 64),
              child: Text(
                getIt<AppLocalizations>().sentenceGettingSplash,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: blackColorTheme,
                    fontSize: messageSize,
                    fontFamily: fontFamilyHind),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            ButtonMain(
                width: width * .8,
                textButton: getIt<AppLocalizations>().titleStart,
                actionButton: ActionButtonLog.start,
                actionDescription: runtimeType.toString(),
                onPressed: () {
                  widget.animationController.animateTo(0.2);
                }),
          ],
        ),
      ),
    );
  }
}
