import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';

class InputSearchCompleteText extends StatelessWidget {
  const InputSearchCompleteText({
    super.key,
    required this.width,
    required this.decoration,
    required this.iconSuffix,
    required this.percentage,
    required this.textInputSearch,
  });

  final double width;
  final InputDecoration? decoration;
  final TextEditingController textInputSearch;
  final InkWell iconSuffix;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: width * 0.15,
      child: Opacity(
        opacity: lerpDouble(0, 1, (0.5 - percentage) * 3)!.clamp(0, 1),
        child: Hero(
          tag: getIt<AppLocalizations>().inputSearchServices,
          child: InputTextField(
              controller: textInputSearch,
              onChanged: (value) {
                getIt<ServiceBloc>().setFilter(context: context, query: value);
              },
              styleInputField: StyleInputField(
                textLabel: getIt<AppLocalizations>().inputSearchServices,
                fillColor: whiteColorTheme,
                decoration: decoration,
                icon: iconSearch,
                colorText: secondaryColorTheme,
                additionalPaddingIcon: 3,
                colorIconUnfocus: secondaryColorTheme,
                colorIconFocused: secondaryColorTheme,
                borderEnable: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(rounded28),
                    borderSide: BorderSide(
                      color: secondaryColorTheme.withValues(alpha: 0.4),
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                borderFocus: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(rounded28),
                    borderSide: const BorderSide(
                      color: secondaryColorTheme,
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                sizeIcon: 35,
                width: width * 0.7,
                iconSuffixCustom: iconSuffix,
                height: heightTextFieldSize + 6,
                textInputType: TextInputType.text,
              )),
        ),
      ),
    );
  }
}
