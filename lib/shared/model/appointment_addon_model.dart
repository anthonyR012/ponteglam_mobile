import 'package:ponte_glam/shared/model/addon_model.dart';

class AppointmentAddonModel {
  final int id;
  final AddonModel addon;
  final double priceAtBooking;
  final int durationAtBooking;

  AppointmentAddonModel({
    required this.id,
    required this.addon,
    required this.priceAtBooking,
    required this.durationAtBooking,
  });

  factory AppointmentAddonModel.fromJson(Map<String, dynamic> json) {
    return AppointmentAddonModel(
      id: json['id'] ?? 0,
      addon: AddonModel.fromJson(json['addon'] ?? {}),
      priceAtBooking: double.tryParse(json['price_at_booking']?.toString() ?? '0') ?? 0.0,
      durationAtBooking: json['duration_at_booking'] ?? 0,
    );
  }
}
