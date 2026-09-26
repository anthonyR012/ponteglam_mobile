import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/sign_up/domain/use_case/get_legal_content.dart';

// ─────────────────────────────────────────────
// PUBLIC HELPERS
// ─────────────────────────────────────────────

void showTermsAndConditionsDialog(BuildContext context) {
  _showLegalSheet(
    context: context,
    title: getIt<AppLocalizations>().titleTermsAndConditionsTitle,
    child: const _LegalContent(typeCode: 'terms_and_conditions'),
  );
}

void showPrivacyPolicyDialog(BuildContext context) {
  _showLegalSheet(
    context: context,
    title: getIt<AppLocalizations>().titlePrivacyPolicy,
    child: const _LegalContent(typeCode: 'privacy_policy'),
  );
}

void showServiceFeePolicyDialog(BuildContext context) {
  _showLegalSheet(
    context: context,
    title: 'Política de Comisiones y Multas',
    child: const _LegalContent(typeCode: 'service_fee_policy'),
  );
}

void _showLegalSheet({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: whiteColorTheme,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(rounded28)),
    ),
    builder: (_) => _LegalSheet(title: title, child: child),
  );
}

// ─────────────────────────────────────────────
// SHARED SHEET SHELL
// ─────────────────────────────────────────────

class _LegalSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _LegalSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.88,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: greyBlockColorTheme,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Icon(Icons.article_outlined,
                    color: secondaryColorTheme, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: h3Size,
                      fontWeight: FontWeight.bold,
                      color: appBarColorTheme,
                      fontFamily: fontFamilyMontserrat,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: child,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColorTheme,
                  foregroundColor: whiteColorTheme,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rounded10),
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    fontSize: h4Size,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamilyMontserrat,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DYNAMIC LEGAL CONTENT
// ─────────────────────────────────────────────

class _LegalContent extends StatelessWidget {
  final String typeCode;

  const _LegalContent({required this.typeCode});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getIt<GetLegalContent>().call(typeCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: secondaryColorTheme,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo cargar el contenido.',
                    style: TextStyle(
                      color: grayTextColorTheme,
                      fontSize: bodySize,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final content = snapshot.data ?? 'No hay contenido disponible.';

        return Text(
          content,
          style: const TextStyle(
            fontSize: bodySize,
            color: appBarColorTheme,
            height: 1.6,
          ),
        );
      },
    );
  }
}
