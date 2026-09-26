import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class EmailContentRecoverWidget extends StatelessWidget {
  const EmailContentRecoverWidget(
      {super.key,
      required this.controllerEmail,
      required this.width,
      required this.sendEmailVerification,
      required this.titlePage});

  final TextEditingController controllerEmail;
  final double width;
  final String titlePage;
  final void Function() sendEmailVerification;

  @override
  Widget build(BuildContext context) {
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
        InputTextField(
          controller: controllerEmail,
          styleInputField: StyleInputField(
              textLabel: getIt<AppLocalizations>().inputEmail,
              width: width,
              textInputType: TextInputType.emailAddress,
              validators: const [ValidatorText.requiredValue, ValidatorText.email]),
        ),
        const SizedBox(height: spaceBetween10),
        ButtonMain(
            width: width,
            textButton: getIt<AppLocalizations>().titleSend,
            actionButton: ActionButtonLog.confirm,
            actionDescription: runtimeType.toString(),
            onPressed: sendEmailVerification),
      ],
    );
  }
}
