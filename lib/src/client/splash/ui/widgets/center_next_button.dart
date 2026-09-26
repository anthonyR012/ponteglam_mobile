import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/line_information_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class CenterNextButton extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;
  final dynamic onTapAlreadyRegistered;
  const CenterNextButton(
      {super.key,
      required this.animationController,
      required this.onNextClick,
      required this.onTapAlreadyRegistered});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final topMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0.05, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final signUpMoveAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final loginTextMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return Padding(
      padding:
          EdgeInsets.only(bottom: 16 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: topMoveAnimation,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => AnimatedOpacity(
                opacity: animationController.value >= 0.2 &&
                        animationController.value <= 0.6
                    ? 1
                    : 0,
                duration: const Duration(milliseconds: 480),
                child: _pageView(),
              ),
            ),
          ),
          SlideTransition(
            position: topMoveAnimation,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => Padding(
                padding: EdgeInsets.only(
                    bottom: 38 - (38 * signUpMoveAnimation.value)),
                child: Container(
                  height: 52,
                  width: 52 + (200 * signUpMoveAnimation.value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        40 + 32 * (1 - signUpMoveAnimation.value)),
                    color: secondaryColorTheme,
                  ),
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 480),
                    reverse: signUpMoveAnimation.value < 0.7,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        fillColor: Colors.transparent,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: child,
                      );
                    },
                    child: signUpMoveAnimation.value > 0.7
                        ? ButtonMain(
                            width: width * .9,
                            textButton: getIt<AppLocalizations>().titleSignUp,
                            onPressed: onNextClick,
                            actionButton: ActionButtonLog.step,
                            actionDescription: runtimeType.toString(),
                            backgroundColor: Colors.transparent,
                            key:
                                ValueKey(getIt<AppLocalizations>().titleSignUp))
                        : InkWell(
                            key: ValueKey(getIt<AppLocalizations>().titleNext),
                            onTap: onNextClick,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                '$pathManagementIcons$iconForwardArrow',
                                colorFilter: const ColorFilter.mode(
                                    whiteColorTheme, BlendMode.srcIn),
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SlideTransition(
              position: loginTextMoveAnimation,
              child: LineInformation(
                inRow: true,
                leftText: getIt<AppLocalizations>().questionAlreadyRegistered,
                rightText: getIt<AppLocalizations>().titleSignIn,
                onTapTextOption: onTapAlreadyRegistered,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageView() {
    int selectedIndex = 0;

    if (animationController.value >= 0.7) {
      selectedIndex = 3;
    } else if (animationController.value >= 0.5) {
      selectedIndex = 2;
    } else if (animationController.value >= 0.3) {
      selectedIndex = 1;
    } else if (animationController.value >= 0.1) {
      selectedIndex = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: selectedIndex == i
                      ? secondaryColorTheme
                      : grayTextColorTheme,
                ),
                width: 10,
                height: 10,
              ),
            )
        ],
      ),
    );
  }
}
