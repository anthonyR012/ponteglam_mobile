import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';

const primaryColorTheme = Color(0xFF5B0055);
const secondaryColorTheme = Color(0xFF009CA1);
const whiteColorTheme = Color(0xFFFFFFFF);
const blackColorTheme = Color(0xFF000000);
const backgroundColorTheme = Color(0xFFFAFAFA);
const grayTextColorTheme = Color(0xFF858585);
const Color seenColorTheme = Color(0xFFE2D34B);
const Color inProgressColorTheme = Color(0xFF086BDF);
const Color successColorTheme = Color(0xFF12B76A);
const Color cancelColorTheme = Color(0xFFF80707);
const Color greyBlockColorTheme = Color(0xFFD0D5DD);
const Color cardColorTheme = Colors.white;
const Color appBarColorTheme = Color(0xFF091522);
const Color borderColorTheme = Color(0xFF3A3A42);
const Color borderColorActiveTheme = Color(0xFFFFFFFF);
Color linearColorTheme = const Color(0xFF176FF2).withValues(alpha: 0.5);
final LinearGradient glamGradientTheme = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xFF028D92),
    const Color(0xFF037D80).withValues(alpha: 0.95),
    const Color(0xFF026D6E).withValues(alpha: 0.8),
    const Color(0xFF025E5E).withValues(alpha: 0.6),
  ],
);
const LinearGradient darkStrongGradientTheme = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(30, 0, 0, 0),
    Color.fromARGB(0, 0, 0, 0),
    Color.fromARGB(20, 255, 255, 255),
  ],
);

const _snackBarTheme = SnackBarThemeData(
  backgroundColor: primaryColorTheme,
  contentTextStyle: TextStyle(
      color: whiteColorTheme,
      fontFamily: fontFamilyHind,
      fontSize: messageSize),
);

final _borderNoSelected = OutlineInputBorder(
    borderRadius: BorderRadius.circular(rounded28),
    borderSide: const BorderSide(
      color: borderColorTheme,
      width: 1,
      style: BorderStyle.solid,
    ));

final _borderSelected = OutlineInputBorder(
    borderRadius: BorderRadius.circular(rounded28),
    borderSide: const BorderSide(
      color: borderColorActiveTheme,
      width: 1,
      style: BorderStyle.solid,
    ));

const _floatingLigth =
    FloatingActionButtonThemeData(backgroundColor: secondaryColorTheme);

final _imputLigth = InputDecorationTheme(
  enabledBorder: _borderNoSelected,
  focusedBorder: _borderSelected,
  fillColor: appBarColorTheme,
  filled: true,
  contentPadding: const EdgeInsets.all(paddingInput15),
  labelStyle: const TextStyle(color: grayTextColorTheme),
);

const _iconLigth = IconThemeData(color: secondaryColorTheme);
const _appBarLigth = AppBarTheme(
  backgroundColor: appBarColorTheme,
);

final _elevatedButton = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(whiteColorTheme),
    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: h3Size)),
  ),
);

final _cardTheme = CardThemeData(
  color: cardColorTheme,
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(rounded10),
  ),
);
// Theme ligth
final ligthTheme = ThemeData(
    appBarTheme: _appBarLigth,
    primaryColor: primaryColorTheme,
    snackBarTheme: _snackBarTheme,
    scaffoldBackgroundColor: backgroundColorTheme,
    floatingActionButtonTheme: _floatingLigth,
    cardTheme: _cardTheme,
    elevatedButtonTheme: _elevatedButton,
    inputDecorationTheme: _imputLigth,
    iconTheme: _iconLigth);
