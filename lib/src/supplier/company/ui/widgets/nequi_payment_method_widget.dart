import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/company_model.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_cubit.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_state.dart';

class NequiPaymentMethodWidget extends StatefulWidget {
  final CompanyModel? company;
  final bool isCreating;
  final TextEditingController? creationController;
  final Function(CompanyModel)? onUpdateSuccess;

  const NequiPaymentMethodWidget({
    super.key,
    this.company,
    this.isCreating = false,
    this.creationController,
    this.onUpdateSuccess,
  });

  @override
  State<NequiPaymentMethodWidget> createState() => _NequiPaymentMethodWidgetState();
}

class _NequiPaymentMethodWidgetState extends State<NequiPaymentMethodWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.isCreating) {
      return ModernTextField(
        controller: widget.creationController ?? TextEditingController(),
        label: l10n.nequiLabel,
        hint: l10n.nequiNumberPlaceholder,
        icon: Icons.phone_android_rounded,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        validator: (value) {
          if (value == null || value.trim().isEmpty) return null;
          if (value.trim().length != 10) {
            return l10n.invalidNequiNumber;
          }
          return null;
        },
      );
    }

    final currentNequi = widget.company?.nequiNumber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernSectionHeader(title: l10n.nequiSectionTitle),
        const SizedBox(height: 15),
        ModernFormCard(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: secondaryColorTheme,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nequiLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: grayTextColorTheme,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentNequi != null && currentNequi.isNotEmpty
                            ? currentNequi
                            : l10n.failureUnavailable,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: currentNequi != null && currentNequi.isNotEmpty
                              ? appBarColorTheme
                              : cancelColorTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: heightButtonSize,
              child: OutlinedButton(
                onPressed: () => _showUpdateDialog(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: secondaryColorTheme, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rounded28),
                  ),
                  foregroundColor: secondaryColorTheme,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      l10n.updateNequiButton,
                      style: TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.bold,
                        fontSize: h3Size,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return BlocProvider<CompanyCubit>.value(
          value: context.read<CompanyCubit>(),
          child: _NequiUpdateDialog(
            companyId: widget.company!.id,
            onSuccess: (updatedCompany) {
              Navigator.of(dialogCtx).pop();
              if (widget.onUpdateSuccess != null) {
                widget.onUpdateSuccess!(updatedCompany);
              }
            },
          ),
        );
      },
    );
  }
}

class _NequiUpdateDialog extends StatefulWidget {
  final int companyId;
  final Function(CompanyModel) onSuccess;

  const _NequiUpdateDialog({
    required this.companyId,
    required this.onSuccess,
  });

  @override
  State<_NequiUpdateDialog> createState() => _NequiUpdateDialogState();
}

class _NequiUpdateDialogState extends State<_NequiUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nequiController = TextEditingController();
  final _otpController = TextEditingController();

  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nequiController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<CompanyCubit, CompanyState>(
      listener: (context, state) {
        if (state is CompanyLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is CompanyNequiVerificationCodeSent) {
          setState(() {
            _codeSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: successColorTheme,
            ),
          );
        } else if (state is CompanyNequiUpdateSuccess) {
          widget.onSuccess(state.company);
        } else if (state is CompanyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: cancelColorTheme,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.updateNequiButton,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryColorTheme,
                  ),
                ),
                const SizedBox(height: 15),
                if (!_codeSent) ...[
                  ModernTextField(
                    controller: _nequiController,
                    label: l10n.nequiLabel,
                    hint: l10n.nequiNumberPlaceholder,
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.failureEmptyField;
                      }
                      if (value.trim().length != 10) {
                        return l10n.invalidNequiNumber;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  Text(
                    l10n.otpNequiMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      color: grayTextColorTheme,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ModernTextField(
                    controller: _otpController,
                    label: l10n.verificationCodeLabel,
                    hint: '12345',
                    icon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.failureEmptyField;
                      }
                      if (value.trim().length < 4) {
                        return l10n.failureInvalidNumberChar(5);
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: secondaryColorTheme),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.titleNoCancelBack.split(',').first,
                          style: const TextStyle(color: grayTextColorTheme),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColorTheme,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _codeSent ? l10n.titleApply : l10n.titleNext,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_codeSent) {
      context.read<CompanyCubit>().requestNequiUpdate(
            companyId: widget.companyId,
          );
    } else {
      context.read<CompanyCubit>().updateNequiNumber(
            companyId: widget.companyId,
            nequiNumber: _nequiController.text.trim(),
            verificationCode: _otpController.text.trim(),
          );
    }
  }
}
