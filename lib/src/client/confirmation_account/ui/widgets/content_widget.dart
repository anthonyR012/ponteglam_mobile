import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/blocs/cubit_confirmation/confirmation_cubit.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class ContentPhoneConfirmationWidet extends StatelessWidget {
  const ContentPhoneConfirmationWidet({
    super.key,
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
    required this.verifyEmail,
    required this.resendCode,
    required this.onTapTimerEnd,
    required this.listener,
    this.isButtonDisabled = false,
  });

  final void Function() verifyEmail;
  final void Function()? resendCode;
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
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode,
      BuildContext context) changeFocusNode;
  final bool isButtonDisabled;
  final void Function() onTapTimerEnd;
  final void Function(BuildContext, ConfirmationState) listener;

  InputDecoration _otpDecoration() {
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: backgroundColorTheme,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: greyBlockColorTheme.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: secondaryColorTheme, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: cancelColorTheme),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: cancelColorTheme, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Widget _otpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String) onChanged,
    required double boxWidth,
  }) {
    return SizedBox(
      width: boxWidth,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLength: allowChar,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? '' : null,
        style: const TextStyle(
          fontSize: h3Size,
          fontWeight: FontWeight.bold,
          color: primaryColorTheme,
        ),
        decoration: _otpDecoration(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<AppLocalizations>();
    final boxWidth = width * 0.13;
    const gap = SizedBox(width: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModernFormCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _otpBox(
                  controller: controllerCode1,
                  focusNode: focusNodeCode1,
                  onChanged: (v) =>
                      changeFocusNode(v, focusNodeCode1, focusNodeCode2, context),
                  boxWidth: boxWidth,
                ),
                gap,
                _otpBox(
                  controller: controllerCode2,
                  focusNode: focusNodeCode2,
                  onChanged: (v) =>
                      changeFocusNode(v, focusNodeCode2, focusNodeCode3, context),
                  boxWidth: boxWidth,
                ),
                gap,
                _otpBox(
                  controller: controllerCode3,
                  focusNode: focusNodeCode3,
                  onChanged: (v) =>
                      changeFocusNode(v, focusNodeCode3, focusNodeCode4, context),
                  boxWidth: boxWidth,
                ),
                gap,
                _otpBox(
                  controller: controllerCode4,
                  focusNode: focusNodeCode4,
                  onChanged: (v) =>
                      changeFocusNode(v, focusNodeCode4, focusNodeCode5, context),
                  boxWidth: boxWidth,
                ),
                gap,
                _otpBox(
                  controller: controllerCode5,
                  focusNode: focusNodeCode5,
                  onChanged: (_) => verifyEmail(),
                  boxWidth: boxWidth,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocListener<ConfirmationCubit, ConfirmationState>(
          listener: listener,
          child: ButtonMain(
            onPressed: verifyEmail,
            width: double.infinity,
            actionButton: ActionButtonLog.confirm,
            actionDescription: runtimeType.toString(),
            textButton: l10n.titleCheck,
          ),
        ),
      ],
    );
  }
}
