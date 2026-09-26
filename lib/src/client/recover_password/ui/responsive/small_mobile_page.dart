import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/blocs/cubit_recover/recover_cubit.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

class SmallMobilePageRecoverPage extends StatefulWidget {
  const SmallMobilePageRecoverPage({
    super.key,
    required this.width,
    required this.height,
    required this.formKey,
    required this.goToSingUp,
    required this.controllerEmail,
    required this.builderRecover,
    required this.listenerRecover,
  });

  final double width;
  final double height;
  final GlobalKey<FormState> formKey;
  final void Function() goToSingUp;
  final TextEditingController controllerEmail;
  final Widget Function(BuildContext, RecoverState, TypeSizeScreenDevice)
      builderRecover;
  final void Function(BuildContext, RecoverState) listenerRecover;

  @override
  State<SmallMobilePageRecoverPage> createState() =>
      _SmallMobilePageRecoverPageState();
}

class _SmallMobilePageRecoverPageState
    extends State<SmallMobilePageRecoverPage> {
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
                      l10n.titleRecover,
                      style: const TextStyle(
                        color: grayTextColorTheme,
                        fontSize: bodySize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                BlocConsumer<RecoverCubit, RecoverState>(
                  builder: (context, state) => widget.builderRecover(
                      context, state, TypeSizeScreenDevice.smallMobile),
                  listener: widget.listenerRecover,
                ),
                const SizedBox(height: 20),
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
                      onTap: widget.goToSingUp,
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
