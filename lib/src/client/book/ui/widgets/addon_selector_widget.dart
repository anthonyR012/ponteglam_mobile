import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_cubit.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_state.dart';

class AddonSelectorWidget extends StatelessWidget {
  final BookingSlotSelected state;

  const AddonSelectorWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingAddons) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColorTheme,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (state.availableAddons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernSectionHeader(title: getIt<AppLocalizations>().titleAddons),
        const SizedBox(height: 4),
        Text(
          'Opcionales · se suman al precio y tiempo total',
          style: const TextStyle(
            color: grayTextColorTheme,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        ...state.availableAddons.map((addon) {
          final isSelected = state.selectedAddons.any((a) => a.id == addon.id);
          return _AddonToggleCard(
            addon: addon,
            isSelected: isSelected,
          );
        }),
      ],
    );
  }
}

class _AddonToggleCard extends StatelessWidget {
  final AddonModel addon;
  final bool isSelected;

  const _AddonToggleCard({
    required this.addon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    final String priceText;
    if (addon.price == 0) {
      priceText = 'Gratis';
    } else {
      priceText = '+${formatCurrency.format(addon.price)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? secondaryColorTheme : greyBlockColorTheme,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: appBarColorTheme,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${addon.durationMinutes} min • $priceText',
                  style: const TextStyle(
                    color: grayTextColorTheme,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isSelected,
            onChanged: (_) {
              context.read<BookingCubit>().toggleAddon(addon);
            },
            activeThumbColor: primaryColorTheme,
            inactiveTrackColor: greyBlockColorTheme,
          ),
        ],
      ),
    );
  }
}
