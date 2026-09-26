import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/di/get_it_instance.dart';

class TopBackSkipView extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onBackClick;
  final VoidCallback onSkipClick;

  const TopBackSkipView({
    super.key,
    required this.onBackClick,
    required this.onSkipClick,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0.0, 0.0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final skipAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(2, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: animation,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBackClick,
                  splashFactory: NoSplash.splashFactory,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      '$pathManagementIcons$iconBackArrow',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                          primaryColorTheme, BlendMode.srcIn),
                    ),
                  ),
                ),
                SlideTransition(
                  position: skipAnimation,
                  child: IconButton(
                    onPressed: onSkipClick,
                    icon: Text(
                      getIt<AppLocalizations>().titleSkip,
                      style: const TextStyle(
                          color: primaryColorTheme,
                          fontSize: h5Size + 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamilyMontserrat),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
