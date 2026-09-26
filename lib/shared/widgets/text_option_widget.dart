import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class TextOptionField extends StatelessWidget {
  const TextOptionField(
      {super.key, required this.text, this.colorText = secondaryColorTheme});
  final String text;
  final Color colorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        maxLines: maxLinesSize,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: fontFamilyMontserrat,
            color: colorText,
            fontSize: minimalMonserratSize + 3),
      ),
    );
  }
}
