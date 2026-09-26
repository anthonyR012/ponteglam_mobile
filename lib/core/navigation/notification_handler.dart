import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/src/client/appointment/ui/appointment_detail_page.dart';
import 'package:ponte_glam/src/client/history/ui/history_page.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';

class NotificationHandler {
  static void handleNotificationTap(
      BuildContext context, Map<String, dynamic> data) {
    final String? goTo = data['go_to'] ?? data['action'];
    if (goTo == null) return;

    final String? appointmentIdStr = data['appointment_id'];
    final int? appointmentId =
        appointmentIdStr != null ? int.tryParse(appointmentIdStr) : null;

    final bool autoOpenRating = data['prompt_rating'] == 'true';

    switch (goTo) {
      case 'history':
      case 'client_appointments':
        context.pushNamed(AppointmentHistory.routeName);
        break;

      case 'appointment_detail':
        if (appointmentId != null) {
          context.pushNamed(
            AppointmentDetailPage.routeName,
            extra: {
              'appointmentId': appointmentId,
              'autoOpenRating': autoOpenRating,
            },
          );
        }
        break;

      case 'supplier_appointments':
        context.pushNamed(HomePageSupplier.routeName);
        break;

      default:
        // go_to desconocido: no navegar a ningún lado para evitar crashes.
        break;
    }
  }
}
