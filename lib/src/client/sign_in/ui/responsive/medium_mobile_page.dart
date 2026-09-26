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
import 'package:ponte_glam/shared/blocs/cubit_sing_in/sign_in_cubit.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/recover_password/ui/recover_password_page.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/sign_up/ui/sign_up_page.dart';
import 'package:ponte_glam/src/client/sign_up/ui/widgets/terms_dialog_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class MediumSignInMobilePage extends StatefulWidget {
  final FocusNode focusNodeEmail;
  final FocusNode focusNodePassword;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final GlobalKey<FormState> formKey;
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode,
      BuildContext context) changeFocusNode;
  final void Function(BuildContext, SignInState) listener;

  const MediumSignInMobilePage({
    super.key,
    required this.listener,
    required this.formKey,
    required this.focusNodeEmail,
    required this.focusNodePassword,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.changeFocusNode,
  });

  @override
  State<MediumSignInMobilePage> createState() => _MediumSignInMobilePageState();
}

class _MediumSignInMobilePageState extends State<MediumSignInMobilePage> {
  bool _showTermsSection = false;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  void _onSignInPressed() {
    if (widget.formKey.currentState!.validate()) {
      context.read<SignInCubit>().doSignIn(
            password: widget.controllerPassword.text,
            userName: widget.controllerEmail.text,
            repository: Repository.api,
            acceptedTerms: _termsAccepted && _privacyAccepted,
          );
    }
  }

  void _onGooglePressed() {
    if (_showTermsSection && (!_termsAccepted || !_privacyAccepted)) {
      PonteSnackBar.show(
        context,
        message: getIt<AppLocalizations>().sentenceAcceptTermsToContinue,
        type: TypeAlert.warning,
      );
      return;
    }
    context.read<SignInCubit>().doSignIn(
        repository: Repository.firebase,
        acceptedTerms: _termsAccepted && _privacyAccepted);
  }

  void _localListener(BuildContext context, SignInState state) {
    if (state is SignInError) {
      final msg = state.messageError.toLowerCase();
      if (msg.contains('término') ||
          msg.contains('termino') ||
          msg.contains('term') ||
          msg.contains('condition')) {
        setState(() => _showTermsSection = true);
      }
    }
    widget.listener(context, state);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<AppLocalizations>();
    return Scaffold(
      backgroundColor: backgroundColorTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
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
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 4,
                      width: 64,
                      decoration: BoxDecoration(
                        gradient: glamGradientTheme,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.sentenceSignInWelcome,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: h4Size,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Section header
                ModernSectionHeader(title: l10n.titleSignIn),
                const SizedBox(height: 12),
                // Form card
                ModernFormCard(
                  children: [
                    ModernTextField(
                      controller: widget.controllerEmail,
                      label: l10n.inputEmail,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: widget.focusNodeEmail,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) => widget.changeFocusNode(
                          value,
                          widget.focusNodeEmail,
                          widget.focusNodePassword,
                          context),
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
                          value, widget.focusNodePassword, FocusNode(), context),
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
                  ],
                ),
                const SizedBox(height: 8),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.pushReplacementNamed(
                        RecoverPasswordPage.routeName),
                    child: Text(
                      l10n.questionForgotPassword,
                      style: const TextStyle(
                        color: secondaryColorTheme,
                        fontSize: bodySize,
                      ),
                    ),
                  ),
                ),
                // Conditional T&C section
                if (_showTermsSection) ...[
                  const SizedBox(height: 4),
                  _LegalCheckbox(
                    value: _termsAccepted,
                    onChanged: (val) =>
                        setState(() => _termsAccepted = val ?? false),
                    prefix: '${l10n.sentenceAcceptTerms} ',
                    linkText: l10n.titleTermsAndConditions,
                    onTapLink: () => showTermsAndConditionsDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _LegalCheckbox(
                    value: _privacyAccepted,
                    onChanged: (val) =>
                        setState(() => _privacyAccepted = val ?? false),
                    prefix: '${l10n.sentenceAcceptPrivacy} ',
                    linkText: l10n.sentencePrivacyLink,
                    suffix: ' ${l10n.sentencePrivacySuffix}',
                    onTapLink: () => showPrivacyPolicyDialog(context),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 4),
                BlocListener<SignInCubit, SignInState>(
                  listener: _localListener,
                  child: const SizedBox.shrink(),
                ),
                // Sign in button
                ButtonMain(
                  width: double.infinity,
                  textButton: l10n.titleSignIn,
                  actionButton: ActionButtonLog.confirm,
                  actionDescription: runtimeType.toString(),
                  onPressed: _onSignInPressed,
                ),
                const SizedBox(height: 20),
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
                // Google sign in — full width
                OutlinedButton.icon(
                  onPressed: _onGooglePressed,
                  icon: SvgPicture.asset(
                    '$pathManagementIcons$iconGoogleMain',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    l10n.titleSignInWithGoogle,
                    style: const TextStyle(
                      color: primaryColorTheme,
                      fontWeight: FontWeight.w600,
                      fontSize: h4Size,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side:
                        const BorderSide(color: primaryColorTheme, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.questionHaveAccount,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: bodySize,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () =>
                          context.pushReplacementNamed(SignUpPage.routeName),
                      child: Text(
                        l10n.titleSignUp,
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
