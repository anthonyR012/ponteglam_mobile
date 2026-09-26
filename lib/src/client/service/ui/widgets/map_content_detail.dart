import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import "package:latlong2/latlong.dart";
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MapSectionDetail extends StatelessWidget {
  const MapSectionDetail({
    super.key,
    required this.width,
    this.location,
    this.address,
    this.height,
    this.onTap,
    this.mapType = MapTypeInteraction.normal,
  });

  final double width;
  final LatLng? location;
  final String? address;
  final double? height;
  final void Function(LatLng)? onTap;
  final MapTypeInteraction mapType;

  Future<void> _openMapApp() async {
    if (location == null) return;

    final lat = location!.latitude;
    final lng = location!.longitude;

    Uri uri;
    if (Platform.isAndroid) {
      uri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($address)');
    } else if (Platform.isIOS) {
      uri = Uri.parse('maps://?q=$address&ll=$lat,$lng');
    } else {
      uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback to browser if app-specific scheme fails
      final browserUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      if (await canLaunchUrl(browserUri)) {
        await launchUrl(browserUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (address == null || location == null) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceBetween10 * 2),
          child: InkWell(
            onTap: _openMapApp,
            borderRadius: BorderRadius.circular(rounded28),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(spaceBetween10 * 2),
              decoration: BoxDecoration(
                color: primaryColorTheme.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(rounded28),
                border: Border.all(
                  color: primaryColorTheme.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(spaceBetween10),
                    decoration: BoxDecoration(
                      color: primaryColorTheme.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      '$pathManagementIcons$iconPointMap',
                      colorFilter: const ColorFilter.mode(
                          primaryColorTheme, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: spaceBetween10 * 1.5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ubicación",
                          style: TextStyle(
                            fontFamily: fontFamilyMontserrat,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primaryColorTheme.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address!,
                          style: const TextStyle(
                            fontFamily: fontFamilyMontserrat,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: primaryColorTheme,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: spaceBetween10 * 3),
      ],
    );
  }
}
