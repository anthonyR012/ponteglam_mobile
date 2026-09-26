import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/src/client/book/ui/book_page.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_cubit.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_state.dart';
import 'package:ponte_glam/src/shared/wallet/ui/page/wallet_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveNowSection extends StatelessWidget {
  const ReserveNowSection(
      {super.key,
      required this.width,
      required this.service,
      required this.headquarter});

  final double width;
  final HeadquarterModel headquarter;
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final hasDebt = walletState.wallet != null && walletState.wallet!.balanceDouble < 0;

        return Padding(
          padding: const EdgeInsets.all(paddingInput15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasDebt)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Tienes una deuda pendiente por cancelación tardía. No puedes realizar nuevas reservas hasta saldarla.',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => context.pushNamed(WalletPage.routeName),
                          child: const Text(
                            'Pagar en Billetera →',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ButtonMain(
                  width: width * 0.55,
                  textButton: hasDebt ? 'Deuda Pendiente' : getIt<AppLocalizations>().titleReserveNow,
                  actionButton: ActionButtonLog.start,
                  backgroundColor: hasDebt ? Colors.grey : primaryColorTheme,
                  actionDescription: runtimeType.toString(),
                  iconCustom: SvgPicture.asset(
                    '$pathManagementIcons$iconForwardArrow',
                    colorFilter:
                        const ColorFilter.mode(whiteColorTheme, BlendMode.srcIn),
                    width: 17,
                    height: 17,
                  ),
                  onPressed: () {
                    if (hasDebt) {
                      context.pushNamed(WalletPage.routeName);
                      return;
                    }
                    context.pushNamed(BookPage.routeName, extra: {
                      "headquarter": headquarter.toJson(),
                      "service": service.toJson(),
                    });
                  }),
              const SizedBox(height: spaceBetween10 * 2.5),
            ],
          ),
        );
      },
    );
  }
}
