import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';

abstract class AppointmentDatasource {
  Future<List<AppointmentModel>> listAppointments({
    required String authToken,
    String? filter,
  });

  Future<List<AppointmentModel>> listSupplierAppointments({
    required String authToken,
    required int serviceId,
    String status = 'upcoming',
  });

  Future<AppointmentModel> getAppointmentDetail({
    required String authToken,
    required int appointmentId,
  });

  Future<void> cancelAppointment({
    required String authToken,
    required int appointmentId,
    String? reason,
  });

  Future<List<AvailableDateModel>> listRescheduleSlots({
    required String authToken,
    required int appointmentId,
  });

  Future<void> rescheduleAppointment({
    required String authToken,
    required int appointmentId,
    required String newStartTime,
  });

  Future<AppointmentModel> confirmCashAppointment({
    required String authToken,
    required int appointmentId,
  });

  Future<void> rateAppointment({
    required String authToken,
    required int appointmentId,
    required int serviceId,
    required int rating,
    required String comment,
  });
}

abstract class AppointmentApiDatasource extends AppointmentDatasource {}
