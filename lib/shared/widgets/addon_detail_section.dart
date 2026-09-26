import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/model/appointment_addon_model.dart';

class AddonDetailSection extends StatelessWidget {
  final List<AppointmentAddonModel> addons;

  const AddonDetailSection({super.key, required this.addons});

  @override
  Widget build(BuildContext context) {
    if (addons.isEmpty) return const SizedBox.shrink();

    final fmt = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    final totalMinutes = addons.fold<int>(0, (sum, a) => sum + a.durationAtBooking);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Row(
          children: const [
            Icon(Icons.add_circle_outline, size: 16, color: primaryColorTheme),
            SizedBox(width: 6),
            Text(
              'Adicionales incluidos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: primaryColorTheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...addons.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.addon.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                          '+${a.durationAtBooking} min',
                          style: const TextStyle(color: grayTextColorTheme, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    a.priceAtBooking == 0 ? 'Gratis' : fmt.format(a.priceAtBooking),
                    style: const TextStyle(
                      color: primaryColorTheme,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 4),
        Text(
          'Tiempo extra: +$totalMinutes min total',
          style: const TextStyle(color: grayTextColorTheme, fontSize: 12),
        ),
      ],
    );
  }
}
