import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/shared/widgets/text_filter_data_widget.dart';

class EditProfileField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool obscureText;
  final bool isDropdown;
  final bool enabled;
  final TextEditingController? controller;
  final double width;
  final FocusNode? focusNode;
  final List<String>? listItems;

  const EditProfileField({
    super.key,
    required this.label,
    required this.initialValue,
    this.controller,
    this.listItems,
    this.obscureText = false,
    this.isDropdown = false,
    this.enabled = true,
    this.width = double.infinity,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isDropdown
            ? TextFilterData(
                onChanged: (suggestion) {},
                focusNode: focusNode ?? FocusNode(),
                controller: controller ?? TextEditingController(),
                styleInputField: StyleInputField(
                  width: width,
                  textLabel: label,
                  colorText: grayTextColorTheme,
                  fillColor: whiteColorTheme,
                  borderEnable: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(rounded28),
                      borderSide: BorderSide(
                        color: grayTextColorTheme.withValues(alpha: 0.4),
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
                ),
                listItems: const [
                  'Afganistán',
                  'Albania',
                  'Baréin',
                  'Bélgica',
                  'Belice',
                  'Burkina Faso',
                  'Burundi',
                  'Chile',
                  'China',
                  'Chipre',
                  'Ciudad del Vaticano',
                  'Colombia',
                ],
              )
            : InputTextField(
                styleInputField: StyleInputField(
                  isObscure: obscureText,
                  initialValue: initialValue,
                  enable: enabled,
                  textLabel: label,
                  labelColor: secondaryColorTheme,
                  fillColor: whiteColorTheme,
                  colorText: grayTextColorTheme,
                  width: width,
                  additionalPaddingIcon: 3,
                  colorIconUnfocus: secondaryColorTheme,
                  colorIconFocused: secondaryColorTheme,
                  borderEnable: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(rounded28),
                      borderSide: BorderSide(
                        color: grayTextColorTheme.withValues(alpha: 0.4),
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
                ),
                controller: controller,
                focusNode: focusNode ?? FocusNode(),
              ));
  }
}
