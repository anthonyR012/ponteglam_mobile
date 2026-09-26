import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class PasswordContentWidget extends StatefulWidget {
  const PasswordContentWidget({
    super.key,
    required this.controllerPassword1,
    required this.width,
    required this.titlePage,
    required this.updatePassword,
    required this.controllerPassword2,
    required this.focusPassword1,
    required this.focusPassword2,
    required this.changeFocusNode,
  });

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
    final l10n = getIt<AppLocalizations>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModernSectionHeader(title: widget.titlePage),
        const SizedBox(height: 12),
        ModernFormCard(
          children: [
            ModernTextField(
              controller: widget.controllerPassword1,
              label: l10n.inputPassword,
              icon: Icons.lock_outline,
              obscureText: true,
              focusNode: widget.focusPassword1,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => widget.changeFocusNode(
                  value, widget.focusPassword1, widget.focusPassword2, context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.failureEmptyField;
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            ModernTextField(
              controller: widget.controllerPassword2,
              label: l10n.inputVerifyPassword,
              icon: Icons.lock_outline,
              obscureText: true,
              focusNode: widget.focusPassword2,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.failureEmptyField;
                }
                if (value != widget.controllerPassword1.text) {
                  return l10n.failureInvalidFormatInputPassword;
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
          onPressed: widget.updatePassword,
        ),
      ],
    );
  }
}
