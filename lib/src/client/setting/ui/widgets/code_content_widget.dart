import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class ContentRecoverPassConfirmationWidet extends StatelessWidget {
  const ContentRecoverPassConfirmationWidet(
      {super.key,
      required this.sizeScreen,
      required this.width,
      required this.controllerCode1,
      required this.controllerCode2,
      required this.controllerCode3,
      required this.controllerCode4,
      required this.focusNodeCode1,
      required this.focusNodeCode2,
      required this.focusNodeCode3,
      required this.focusNodeCode4,
      required this.controllerCode5,
      required this.focusNodeCode5,
      required this.changeFocusNode,
      required this.validatorInput,
      required this.verifyEmail,
      required this.titlePage});
  final void Function() verifyEmail;
  final String? Function(String? value) validatorInput;
  final TypeSizeScreenDevice sizeScreen;
  final double width;
  final TextEditingController controllerCode1;
  final TextEditingController controllerCode2;
  final TextEditingController controllerCode3;
  final TextEditingController controllerCode4;
  final TextEditingController controllerCode5;
  final FocusNode focusNodeCode1;
  final FocusNode focusNodeCode2;
  final FocusNode focusNodeCode3;
  final FocusNode focusNodeCode4;
  final FocusNode focusNodeCode5;
  final int allowChar = 1;
  final String titlePage;
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode,
      BuildContext context) changeFocusNode;

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    StyleInputField styleInputField = StyleInputField(
      textLabel: "",
      width: width * 0.11,
      textInputType: TextInputType.number,
      maxLength: allowChar,
      validators: const [ValidatorText.requiredValue],
    );
    if (sizeScreen == TypeSizeScreenDevice.extraBigMobile) {
      child = TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: animation1000Milliseconds),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child!);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputTextField(
                controller: controllerCode1,
                styleInputField: styleInputField,
                onChanged: (value) => changeFocusNode(
                    value, focusNodeCode1, focusNodeCode2, context),
                focusNode: focusNodeCode1,
              ),
              const SizedBox(width: spaceBetween10 / 2),
              InputTextField(
                controller: controllerCode2,
                styleInputField: styleInputField,
                onChanged: (value) => changeFocusNode(
                    value, focusNodeCode2, focusNodeCode3, context),
                focusNode: focusNodeCode2,
              ),
              const SizedBox(width: spaceBetween10 / 2),
              InputTextField(
                controller: controllerCode3,
                styleInputField: styleInputField,
                onChanged: (value) => changeFocusNode(
                    value, focusNodeCode3, focusNodeCode4, context),
                focusNode: focusNodeCode3,
              ),
              const SizedBox(width: spaceBetween10 / 2),
              InputTextField(
                controller: controllerCode4,
                styleInputField: styleInputField,
                focusNode: focusNodeCode4,
                onChanged: (value) => changeFocusNode(
                    value, focusNodeCode4, focusNodeCode5, context),
              ),
              const SizedBox(width: spaceBetween10 / 2),
              InputTextField(
                controller: controllerCode5,
                styleInputField: styleInputField,
                focusNode: focusNodeCode5,
                onChanged: (value) => verifyEmail(),
              ),
              const SizedBox(width: spaceBetween10 / 2),
              ButtonMain(
                  width: width * 0.2,
                  actionButton: ActionButtonLog.confirm,
                  actionDescription: runtimeType.toString(),
                  textButton: getIt<AppLocalizations>().titleCheck,
                  onPressed: verifyEmail),
            ],
          ));
    } else {
      double valuePercentage = 0.08;
      child = TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: animation1000Milliseconds),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child!);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputTextField(
                    controller: controllerCode1,
                    styleInputField: styleInputField.copyWith(
                        width: width * valuePercentage),
                    focusNode: focusNodeCode1,
                    onChanged: (value) => changeFocusNode(
                        value, focusNodeCode1, focusNodeCode2, context),
                  ),
                  const SizedBox(width: spaceBetween10 / 2),
                  InputTextField(
                    controller: controllerCode2,
                    focusNode: focusNodeCode2,
                    styleInputField: styleInputField.copyWith(
                        width: width * valuePercentage),
                    onChanged: (value) => changeFocusNode(
                        value, focusNodeCode2, focusNodeCode3, context),
                  ),
                  const SizedBox(width: spaceBetween10 / 2),
                  InputTextField(
                    controller: controllerCode3,
                    focusNode: focusNodeCode3,
                    styleInputField: styleInputField.copyWith(
                        width: width * valuePercentage),
                    onChanged: (value) => changeFocusNode(
                        value, focusNodeCode3, focusNodeCode4, context),
                  ),
                  const SizedBox(width: spaceBetween10 / 2),
                  InputTextField(
                    controller: controllerCode4,
                    styleInputField: styleInputField.copyWith(
                        width: width * valuePercentage),
                    focusNode: focusNodeCode4,
                    onChanged: (value) => changeFocusNode(
                        value, focusNodeCode4, focusNodeCode5, context),
                  ),
                  const SizedBox(width: spaceBetween10 / 2),
                  InputTextField(
                    controller: controllerCode5,
                    styleInputField: styleInputField.copyWith(
                        width: width * valuePercentage),
                    focusNode: focusNodeCode5,
                    onChanged: (value) => verifyEmail(),
                  ),
                ],
              ),
              const SizedBox(height: spaceBetween10 * 2),
              ButtonMain(
                  width: width,
                  textButton: getIt<AppLocalizations>().titleCheck,
                  actionButton: ActionButtonLog.confirm,
                  actionDescription: runtimeType.toString(),
                  onPressed: verifyEmail),
            ],
          ));
    }
    return Column(
      children: [
        Text(
          titlePage,
          style: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
              color: whiteColorTheme,
              fontSize: h3Size),
        ),
        const SizedBox(height: spaceBetween30),
        child,
      ],
    );
  }
}
