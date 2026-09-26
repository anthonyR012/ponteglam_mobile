import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class TextLabelWidget extends StatelessWidget {
  const TextLabelWidget({
    super.key,
    required this.text,
    this.styleTextItem = const StyleTextItem(),
  });

  final String text;
  final StyleTextItem styleTextItem;

  @override
  Widget build(BuildContext context) {
    TextStyle style = styleTextItem.customStyle ??
        TextStyle(
            fontFamily: styleTextItem.font,
            fontWeight: styleTextItem.fontWeight,
            color: styleTextItem.colorText,
            fontSize: styleTextItem.fontSize);
    if (styleTextItem.gradientText != null) {
      return GradientText(
        text,
        gradient: styleTextItem.gradientText!,
        style: style,
      );
    }
    return Text(
      text,
      textAlign: styleTextItem.textAlign,
      style: style,
      overflow: TextOverflow.ellipsis,
      maxLines: styleTextItem.maxLines ?? 2,
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle style;

  const GradientText(this.text,
      {super.key, required this.gradient, required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

class StyleTextItem {
  final FontWeight fontWeight;
  final Color colorText;
  final Gradient? gradientText;
  final double fontSize;
  final TextAlign textAlign;
  final int? maxLines;
  final String font;
  final TextStyle? customStyle;

  const StyleTextItem({
    this.customStyle,
    this.font = fontFamilyMontserrat,
    this.fontWeight = FontWeight.bold,
    this.colorText = primaryColorTheme,
    this.fontSize = h1Size,
    this.textAlign = TextAlign.center,
    this.gradientText,
    this.maxLines,
  });

  StyleTextItem copyWith({
    FontWeight? fontWeight,
    Color? colorText,
    Gradient? gradientText,
    double? fontSize,
    TextAlign? textAlign,
    int? maxLines,
    String? font,
    TextStyle? customStyle,
  }) {
    return StyleTextItem(
      fontWeight: fontWeight ?? this.fontWeight,
      colorText: colorText ?? this.colorText,
      gradientText: gradientText ?? this.gradientText,
      fontSize: fontSize ?? this.fontSize,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
      font: font ?? this.font,
      customStyle: customStyle ?? this.customStyle,
    );
  }
}
