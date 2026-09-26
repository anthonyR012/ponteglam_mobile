import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';

class BookingSummaryWidget extends StatelessWidget {
  const BookingSummaryWidget({
    super.key,
    required this.slot,
    required this.serviceName,
    required this.price,
    required this.isHomeService,
    this.homeServicePrice,
    required this.headquarterName,
    required this.address,
    this.selectedHomeAddress,
    this.selectedAddons = const [],
  });

  final AvailableSlotModel slot;
  final String serviceName;
  final double price;
  final bool isHomeService;
  final double? homeServicePrice;
  final String headquarterName;
  final String address;
  final AddressModel? selectedHomeAddress;
  final List<AddonModel> selectedAddons;

  @override
  Widget build(BuildContext context) {
    final startDt = AppDateUtils.fromUtc(DateTime.parse(slot.startTime));
    final endDt = AppDateUtils.fromUtc(DateTime.parse(slot.endTime));
    
    // Day and date string formatting
    final locale = Localizations.localeOf(context).toString();
    final dateStr = DateFormat('EEEE, d MMMM, yyyy', locale).format(startDt);
    final startStr = DateFormat('h:mm a').format(startDt);
    final endStr = DateFormat('h:mm a').format(endDt);
    final baseDuration = endDt.difference(startDt).inMinutes;

    final addHomePrice =
        isHomeService && homeServicePrice != null && homeServicePrice! > 0;
    
    final addonsPrice = selectedAddons.fold<double>(0, (sum, a) => sum + a.price);
    final totalPrice = (addHomePrice ? price + homeServicePrice! : price) + addonsPrice;
    
    final totalAddonMinutes = selectedAddons.fold<int>(0, (sum, a) => sum + a.durationMinutes);
    final adjustedEndDt = endDt.add(Duration(minutes: totalAddonMinutes));
    final adjustedEndStr = DateFormat('h:mm a').format(adjustedEndDt);
    final totalDuration = baseDuration + totalAddonMinutes;

    final fmt =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greyBlockColorTheme.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColorTheme.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: primaryColorTheme,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Resumen de tu reserva',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: appBarColorTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: greyBlockColorTheme),
          const SizedBox(height: 16),

          // Detail Section Rows
          _SummaryItemRow(
            icon: Icons.spa_outlined,
            label: 'Servicio',
            value: serviceName,
          ),
          _SummaryItemRow(
            icon: Icons.location_on_outlined,
            label: 'Ubicación',
            value: '$address ($headquarterName)',
          ),
          _SummaryItemRow(
            icon: Icons.person_outline,
            label: 'Profesional',
            value: slot.workerName,
          ),
          _SummaryItemRow(
            icon: Icons.calendar_today_outlined,
            label: 'Fecha',
            value: dateStr,
          ),
          _SummaryItemRow(
            icon: Icons.access_time,
            label: 'Hora de inicio',
            value: '$startStr ($baseDuration min)',
          ),

          // Addon adjusted end time (Hora final)
          if (totalAddonMinutes > 0) ...[
            _SummaryItemRow(
              icon: Icons.timer_outlined,
              label: 'Hora final',
              value: adjustedEndStr,
              subtitle: 'Duración total: $totalDuration min\n($baseDuration min base + $totalAddonMinutes min adicionales)',
              isHighlighted: true,
            ),
          ] else ...[
            _SummaryItemRow(
              icon: Icons.access_time_filled_outlined,
              label: 'Hora de finalización',
              value: '$endStr ($baseDuration min totales)',
            ),
          ],

          // Home Service row if selected
          if (isHomeService && selectedHomeAddress != null) ...[
            _SummaryItemRow(
              icon: Icons.home_outlined,
              label: 'Dirección domicilio',
              value: selectedHomeAddress!.address,
            ),
          ],

          // Selected Addons Sub-Section
          if (selectedAddons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColorTheme,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyBlockColorTheme.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adicionales agregados:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: appBarColorTheme,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...selectedAddons.map((addon) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                color: secondaryColorTheme,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                addon.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: appBarColorTheme,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            addon.price == 0 ? 'Gratis' : '+${fmt.format(addon.price)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: secondaryColorTheme,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: greyBlockColorTheme),
          const SizedBox(height: 16),

          // Pricing Summary Highlight Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColorTheme.withValues(alpha: 0.05),
                  secondaryColorTheme.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColorTheme.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Valor Base Servicio',
                      style: TextStyle(
                        fontSize: 13,
                        color: grayTextColorTheme,
                      ),
                    ),
                    Text(
                      fmt.format(price),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: appBarColorTheme,
                      ),
                    ),
                  ],
                ),
                if (addHomePrice) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Costo Domicilio',
                        style: TextStyle(
                          fontSize: 13,
                          color: grayTextColorTheme,
                        ),
                      ),
                      Text(
                        '+${fmt.format(homeServicePrice)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: secondaryColorTheme,
                        ),
                      ),
                    ],
                  ),
                ],
                if (selectedAddons.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Valor Adicionales',
                        style: TextStyle(
                          fontSize: 13,
                          color: grayTextColorTheme,
                        ),
                      ),
                      Text(
                        '+${fmt.format(addonsPrice)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: secondaryColorTheme,
                        ),
                      ),
                    ],
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: greyBlockColorTheme),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Estimado',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: appBarColorTheme,
                      ),
                    ),
                    Text(
                      fmt.format(totalPrice),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: primaryColorTheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItemRow extends StatelessWidget {
  const _SummaryItemRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isHighlighted ? secondaryColorTheme : grayTextColorTheme,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: grayTextColorTheme,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    color: isHighlighted ? secondaryColorTheme : appBarColorTheme,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isHighlighted ? secondaryColorTheme.withValues(alpha: 0.8) : grayTextColorTheme,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
