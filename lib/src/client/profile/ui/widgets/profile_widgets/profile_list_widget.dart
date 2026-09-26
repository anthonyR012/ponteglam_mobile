import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/personal_information_widgets/personal_information_page.dart';
import 'package:ponte_glam/shared/widgets/button_forward_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/adresses_available_widget.dart';
import 'package:ponte_glam/src/client/sign_up/ui/widgets/terms_dialog_widget.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  void _launchPrivacyUrl(BuildContext context) {
    showPrivacyPolicyDialog(context);
  }

  void _showDeleteAccountDialog(BuildContext context) {
    PonteAlertDialog.show(
      context,
      title: 'Eliminar cuenta',
      message:
          '¿Estás seguro de que deseas eliminar tu cuenta de forma permanente? \n\n'
          'Se eliminarán todos tus datos personales, direcciones, sedes y servicios asociados. '
          'Tendrás 30 días para volver a iniciar sesión y cancelar la eliminación. Después de este tiempo, la eliminación será irreversible.',
      confirmText: 'Eliminar permanentemente',
      isDanger: true,
      onConfirm: () {
        PonteSnackBar.show(
          context,
          message: 'El perfil se eliminará en 30 días.',
          type: TypeAlert.info,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ParamsButtonForward> buttons = [
      ParamsButtonForward(
        iconLending: iconProfile,
        description: getIt<AppLocalizations>().titlePersonalInformation,
        onTap: () {
          context.push(
              "/${ProfilePage.routeName}/${PersonalInformationPage.routeName}");
        },
      ),
      ParamsButtonForward(
        iconLending: iconAddress,
        description: getIt<AppLocalizations>().titleAddresses,
        onTap: () {
          context.push("/${ProfilePage.routeName}/${AddressesPage.routeName}");
        },
      ),
      ParamsButtonForward(
        iconLending: iconSecurity,
        description: getIt<AppLocalizations>().titlePrivacy,
        onTap: () => _launchPrivacyUrl(context),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return ButtonForwadIcon(
                  param: buttons[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteAccountDialog(context),
              icon: const Icon(Icons.delete_forever_rounded,
                  color: cancelColorTheme),
              label: const Text('Eliminar perfil permanentemente',
                  style: TextStyle(color: cancelColorTheme)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: cancelColorTheme),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
