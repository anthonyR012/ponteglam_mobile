import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class PasswordContentWidget extends StatefulWidget {
  const PasswordContentWidget(
      {super.key,
      required this.controllerPassword1,
      required this.width,
      required this.titlePage,
      required this.updatePassword,
      required this.controllerPassword2,
      required this.focusPassword1,
      required this.focusPassword2,
      required this.changeFocusNode});
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode,
      BuildContext context) changeFocusNode;
  final TextEditingController controllerPassword1;
  final TextEditingController controllerPassword2;
  final FocusNode focusPassword1;
  final FocusNode focusPassword2;
  final String titlePage;
  final double width;
  final void Function() updatePassword;

  @override
  State<PasswordContentWidget> createState() => _PasswordContentWidgetState();
}

class _PasswordContentWidgetState extends State<PasswordContentWidget> {
  @override
  Widget build(BuildContext context) {
    final StyleInputField styleInputField = StyleInputField(
      textLabel: getIt<AppLocalizations>().inputPassword,
      isObscure: true,
      validators: const [ValidatorText.requiredValue],
      width: widget.width,
    );
    return Column(
      children: [
        Text(
          widget.titlePage,
          style: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
              color: whiteColorTheme,
              fontSize: h3Size),
        ),
        const SizedBox(height: spaceBetween30),
        InputTextField(
          controller: widget.controllerPassword1,
          styleInputField: styleInputField,
          onSubmitted: (value) => widget.changeFocusNode(
              value, widget.focusPassword1, widget.focusPassword2, context),
          focusNode: widget.focusPassword1,
        ),
        const SizedBox(height: spaceBetween10),
        InputTextField(
          controller: widget.controllerPassword2,
          styleInputField: styleInputField.copyWith(
              textLabel: getIt<AppLocalizations>().inputVerifyPassword,
              validators: const [
                ValidatorText.requiredValue,
                ValidatorText.verifyPassword
              ]),
          compareWith: widget.controllerPassword1,
          focusNode: widget.focusPassword2,
        ),
        const SizedBox(height: spaceBetween10),
        ButtonMain(
            width: widget.width,
            actionButton: ActionButtonLog.confirm,
            actionDescription: runtimeType.toString(),
            textButton: getIt<AppLocalizations>().titleSend,
            onPressed: widget.updatePassword),
      ],
    );
  }
}
