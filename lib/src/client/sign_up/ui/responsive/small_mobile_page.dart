import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/blocs/cubit_sign_up/sign_up_cubit.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/sign_in/ui/sign_in_page.dart';
import 'package:ponte_glam/src/client/sign_up/ui/widgets/terms_dialog_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class SmallMobilePersonalInformationPage extends StatefulWidget {
  const SmallMobilePersonalInformationPage({
    super.key,
    required this.focusNodeName,
    required this.focusNodeEmail,
    required this.focusNodePassword,
    required this.controllerName,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.formKey,
    required this.changeFocusNode,
    required this.listener,
    required this.signUp,
    required this.signUpWithGoogle,
  });

  final FocusNode focusNodeName;
  final FocusNode focusNodeEmail;
  final FocusNode focusNodePassword;
  final TextEditingController controllerName;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final GlobalKey<FormState> formKey;
  final void Function() signUp;
  final void Function(bool acceptedTerms) signUpWithGoogle;
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode)
      changeFocusNode;
  final void Function(BuildContext, SignUpState) listener;

  @override
  State<SmallMobilePersonalInformationPage> createState() =>
      _SmallMobilePersonalInformationPageState();
}

class _SmallMobilePersonalInformationPageState
    extends State<SmallMobilePersonalInformationPage> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  void _onSignUpPressed() {
    if (!_termsAccepted) {
      _showError(getIt<AppLocalizations>().failureTermsRequired);
      return;
    }
    if (!_privacyAccepted) {
      _showError(getIt<AppLocalizations>().failurePrivacyRequired);
      return;
    }
    widget.signUp();
  }

  void _onSignUpWithGooglePressed() {
    if (!_termsAccepted) {
      _showError(getIt<AppLocalizations>().failureTermsRequired);
      return;
    }
    if (!_privacyAccepted) {
      _showError(getIt<AppLocalizations>().failurePrivacyRequired);
      return;
    }
    widget.signUpWithGoogle(_termsAccepted && _privacyAccepted);
  }

  void _showError(String message) {
    PonteSnackBar.show(
      context,
      message: message,
      type: TypeAlert.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<AppLocalizations>();
    return Scaffold(
      backgroundColor: backgroundColorTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text-only brand header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.app_title,
                      style: const TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.bold,
                        color: primaryColorTheme,
                        fontSize: h1Size,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 4,
                      width: 56,
                      decoration: BoxDecoration(
                        gradient: glamGradientTheme,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.sentenceSignUpCreate,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: bodySize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ModernSectionHeader(title: l10n.titleSignUp),
                const SizedBox(height: 12),
                // Form card
                ModernFormCard(
                  children: [
                    ModernTextField(
                      controller: widget.controllerName,
                      label: l10n.inputName,
                      icon: Icons.person_outline,
                      focusNode: widget.focusNodeName,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) => widget.changeFocusNode(
                          value, widget.focusNodeName, widget.focusNodeEmail),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.failureEmptyField;
                        }
                        if (value.length < 3) {
                          return l10n.failureInvalidFormatInputPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    ModernTextField(
                      controller: widget.controllerEmail,
                      label: l10n.inputEmail,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: widget.focusNodeEmail,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) => widget.changeFocusNode(value,
                          widget.focusNodeEmail, widget.focusNodePassword),
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
                    const SizedBox(height: 15),
                    ModernTextField(
                      controller: widget.controllerPassword,
                      label: l10n.inputPassword,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      focusNode: widget.focusNodePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) => widget.changeFocusNode(
                          value, widget.focusNodePassword, FocusNode()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.failureEmptyField;
                        }
                        if (value.length < 8 || value.length > 15) {
                          return 'La contraseña debe tener entre 8 y 15 caracteres';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Debe tener al menos una mayúscula';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Debe tener al menos una minúscula';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Debe tener al menos un número';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Checkbox 1: Terms and conditions
                _LegalCheckbox(
                  value: _termsAccepted,
                  onChanged: (val) =>
                      setState(() => _termsAccepted = val ?? false),
                  prefix: '${l10n.sentenceAcceptTerms} ',
                  linkText: l10n.titleTermsAndConditions,
                  onTapLink: () => showTermsAndConditionsDialog(context),
                ),
                const SizedBox(height: 8),
                // Checkbox 2: Privacy policy
                _LegalCheckbox(
                  value: _privacyAccepted,
                  onChanged: (val) =>
                      setState(() => _privacyAccepted = val ?? false),
                  prefix: '${l10n.sentenceAcceptPrivacy} ',
                  linkText: l10n.sentencePrivacyLink,
                  suffix: ' ${l10n.sentencePrivacySuffix}',
                  onTapLink: () => showPrivacyPolicyDialog(context),
                ),
                const SizedBox(height: 20),
                // Sign up button
                BlocListener<SignUpCubit, SignUpState>(
                  listener: widget.listener,
                  child: ButtonMain(
                    width: double.infinity,
                    actionButton: ActionButtonLog.step,
                    actionDescription: runtimeType.toString(),
                    textButton: l10n.titleSignUp,
                    onPressed: _onSignUpPressed,
                  ),
                ),
                const SizedBox(height: 16),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.sentenceOrSignIn,
                        style: const TextStyle(
                          color: grayTextColorTheme,
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                // Sign up with Google
                OutlinedButton.icon(
                  onPressed: _onSignUpWithGooglePressed,
                  icon: SvgPicture.asset(
                    '$pathManagementIcons$iconGoogleMain',
                    width: 28,
                    height: 28,
                  ),
                  label: Text(
                    l10n.titleSignUpWithGoogle,
                    style: const TextStyle(
                      color: primaryColorTheme,
                      fontWeight: FontWeight.w600,
                      fontSize: bodySize,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side:
                        const BorderSide(color: primaryColorTheme, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.questionAlreadyRegistered,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: bodySize,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () =>
                          context.pushReplacementNamed(SignInPage.routeName),
                      child: Text(
                        l10n.titleSignIn,
                        style: const TextStyle(
                          color: secondaryColorTheme,
                          fontSize: bodySize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;
  final String prefix;
  final String linkText;
  final String? suffix;
  final VoidCallback onTapLink;

  const _LegalCheckbox({
    required this.value,
    required this.onChanged,
    required this.prefix,
    required this.linkText,
    this.suffix,
    required this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: secondaryColorTheme,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: grayTextColorTheme,
                fontSize: bodySize,
                height: 1.4,
              ),
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: linkText,
                  style: const TextStyle(
                    color: secondaryColorTheme,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTapLink,
                ),
                if (suffix != null) TextSpan(text: suffix),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
