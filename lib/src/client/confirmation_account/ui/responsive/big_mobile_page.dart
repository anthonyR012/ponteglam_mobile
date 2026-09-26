import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/blocs/cubit_confirmation/confirmation_cubit.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/widgets/content_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/src/client/sign_in/ui/sign_in_page.dart';

class BigMobileConfirmationAccountPage extends StatelessWidget {
  const BigMobileConfirmationAccountPage({
    super.key,
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
    required this.formKey,
    required this.changeFocusNode,
    required this.verifyEmail,
    required this.isButtonDisabled,
    required this.resendCode,
    required this.onTapTimerEnd,
    required this.getResendProvider,
    required this.listener,
    required this.user,
  });

  final bool isButtonDisabled;
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
  final GlobalKey<FormState> formKey;
  final Widget Function() getResendProvider;
  final void Function(String value, FocusNode unFocusNode, FocusNode focusNode,
      BuildContext context) changeFocusNode;
  final void Function() verifyEmail;
  final void Function()? resendCode;
  final void Function() onTapTimerEnd;
  final void Function(BuildContext, ConfirmationState) listener;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<AppLocalizations>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColorTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      l10n.sentenceConfirmYourEmail,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: h4Size,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email ?? '',
                      style: const TextStyle(
                        color: secondaryColorTheme,
                        fontSize: h4Size,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleImageProfile(
                      size: 56,
                      showSubIcon: false,
                      typeSourceImage: TypeSourceImage.network,
                      imageMain: user.picture,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        user.fullName ?? '',
                        style: const TextStyle(
                          fontFamily: fontFamilyMontserrat,
                          fontWeight: FontWeight.bold,
                          color: primaryColorTheme,
                          fontSize: h3Size,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ModernSectionHeader(title: l10n.sentenceDigitCodeSended),
                const SizedBox(height: 12),
                ContentPhoneConfirmationWidet(
                  sizeScreen: TypeSizeScreenDevice.bigMobile,
                  width: width,
                  controllerCode1: controllerCode1,
                  controllerCode2: controllerCode2,
                  controllerCode3: controllerCode3,
                  controllerCode4: controllerCode4,
                  controllerCode5: controllerCode5,
                  focusNodeCode1: focusNodeCode1,
                  focusNodeCode2: focusNodeCode2,
                  focusNodeCode3: focusNodeCode3,
                  focusNodeCode4: focusNodeCode4,
                  focusNodeCode5: focusNodeCode5,
                  changeFocusNode: changeFocusNode,
                  resendCode: resendCode,
                  onTapTimerEnd: onTapTimerEnd,
                  listener: listener,
                  verifyEmail: verifyEmail,
                  isButtonDisabled: isButtonDisabled,
                ),
                const SizedBox(height: 12),
                getResendProvider(),
                const SizedBox(height: 24),
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
