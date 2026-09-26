import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';

void showCustomBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    useSafeArea: false,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    isScrollControlled: true,
    backgroundColor: whiteColorTheme,
    sheetAnimationStyle: AnimationStyle(
        duration: Durations.extralong3, curve: Curves.decelerate),
    builder: (BuildContext context) {
      return child;
    },
  );
}
