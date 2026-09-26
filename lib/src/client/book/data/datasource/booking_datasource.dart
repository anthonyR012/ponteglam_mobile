import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/book/data/model/create_appointment_response.dart';

abstract class BookingDatasource {
  Future<CreateAppointmentResponse> createAppointment({
    required String authToken,
    required int serviceId,
    required int workerId,
    required String startTime,
    required String endTime,
    String paymentMethod,
    bool isHomeService,
    int? homeAddressId,
    List<int>? addonIds,
  });

  Future<List<AvailableDateModel>> getAvailableDates({
    required String authToken,
    required int serviceId,
    int? workerId,
    int? headQuarterId,
    int days,
  });
}

abstract class BookingApiDatasource extends BookingDatasource {}
