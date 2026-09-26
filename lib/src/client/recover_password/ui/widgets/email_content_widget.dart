import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class EmailContentRecoverWidget extends StatelessWidget {
  const EmailContentRecoverWidget({
    super.key,
    required this.controllerEmail,
    required this.width,
    required this.sendEmailVerification,
    required this.titlePage,
  });

  final TextEditingController controllerEmail;
  final double width;
  final String titlePage;
  final void Function() sendEmailVerification;

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<AppLocalizations>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModernSectionHeader(title: titlePage),
        const SizedBox(height: 12),
        ModernFormCard(
          children: [
            ModernTextField(
              controller: controllerEmail,
              label: l10n.inputEmail,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.failureEmptyField;
                }
                if (!value.contains('@')) {
                  return l10n.failureInvalidFormatInputEmail;
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        ButtonMain(
          width: double.infinity,
          textButton: l10n.titleSend,
          actionButton: ActionButtonLog.confirm,
          actionDescription: runtimeType.toString(),
          onPressed: sendEmailVerification,
        ),
      ],
    );
  }
}
