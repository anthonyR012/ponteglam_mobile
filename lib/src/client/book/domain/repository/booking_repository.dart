import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/book/data/model/create_appointment_response.dart';

abstract class BookingRepository {
  Future<Either<Failure, CreateAppointmentResponse>> createAppointment({
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

  Future<Either<Failure, List<AvailableDateModel>>> getAvailableDates({
    required String authToken,
    required int serviceId,
    int? workerId,
    int? headQuarterId,
    int days,
  });
}
