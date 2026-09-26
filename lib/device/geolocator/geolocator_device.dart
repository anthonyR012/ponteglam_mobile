import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/device/geolocator/location_exceptions.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/di/get_it_instance.dart';

class GeoDevice {
  Position? _lastPositionRegistered;
  Future<Position>? _currentPositionFuture;

  Future<Position> getCurrentPosition() async {
    if (_currentPositionFuture != null) {
      return _currentPositionFuture!;
    }

    _currentPositionFuture = _getCurrentPositionInternal();
    try {
      return await _currentPositionFuture!;
    } finally {
      _currentPositionFuture = null;
    }
  }

  Future<Position> _getCurrentPositionInternal() async {
    try {
      // 1. Verificar y solicitar permisos si es necesario
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw PonteLocationPermissionDeniedException();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw PonteLocationPermissionDeniedException(
            "Permission denied forever");
      }

      // 2. Verificar si los servicios de ubicación están activos con timeout
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 2), onTimeout: () => false);
      if (!serviceEnabled) {
        throw PonteLocationServiceDisabledException();
      }

      // 3. Obtener la posición con un timeout más corto para evitar bloqueos prolongados
      _lastPositionRegistered ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(const Duration(seconds: 5));

      return _lastPositionRegistered!;
    } catch (e) {
      if (_lastPositionRegistered != null) return _lastPositionRegistered!;
      throw getIt<AppLocalizations>()
          .failureInsufficientPermission("ubicación");
    }
  }

  Future<void> checkPermission() async {
    late LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    }
  }

  void openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled()
        .timeout(const Duration(seconds: 2), onTimeout: () => false);
  }

  void openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> promptEnableLocation(BuildContext context) async {
    await PonteAlertDialog.show(
      context,
      title: 'Ubicación desactivada',
      message:
          'Para ofrecerte una mejor experiencia y mostrarte servicios cerca de ti, necesitamos que actives tu ubicación.',
      confirmText: 'Activar GPS',
      cancelText: 'Después',
      onConfirm: () => openLocationSettings(),
    );
  }

  Future<List<Placemark>> getAddressFromPosition(Position position) async {
    try {
      // Timeout para evitar que la búsqueda de dirección bloquee la UI
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude)
              .timeout(const Duration(seconds: 3));
      return placemarks;
    } catch (e) {
      return [];
    }
  }

  Future<String> distanceTo(LatLng to, {bool minChar = true}) async {
    try {
      _lastPositionRegistered ??= await getCurrentPosition();
      const double earthRadius = 6371; // in kilometers
      final LatLng from = LatLng(_lastPositionRegistered!.latitude,
          _lastPositionRegistered!.longitude);
      // Convert degrees to radians
      double lat1 = _degreesToRadians(from.latitude);
      double lon1 = _degreesToRadians(from.longitude);
      double lat2 = _degreesToRadians(to.latitude);
      double lon2 = _degreesToRadians(to.longitude);
      // Calculate differences
      double dLat = lat2 - lat1;
      double dLon = lon2 - lon1;
      // Apply Haversine formula
      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double distance = earthRadius * c;
      distance = earthRadius * c;
      String prefix = "";
      final localizations = getIt<AppLocalizations>();
      if (distance < 1) {
        distance = distance * 1000;
        prefix = minChar
            ? localizations.titleMeterPreffixAcronym
            : localizations.titleMeterPreffix;
      } else {
        distance = distance;
        prefix = minChar
            ? localizations.titleKilometerPreffixAcronym
            : localizations.titleKilometerPreffix;
      }
      return '${distance.toStringAsFixed(2)} $prefix';
    } catch (e) {
      return "0.0 ${getIt<AppLocalizations>().titleKilometerPreffixAcronym}";
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
