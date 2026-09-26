import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';

class TextLineDescription extends StatelessWidget {
  const TextLineDescription({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: grayTextColorTheme,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: paddingVerticalButton),
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: fontFamilyLora,
                color: grayTextColorTheme,
                fontSize: bodySize),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: grayTextColorTheme,
          ),
        ),
      ],
    );
  }
}
