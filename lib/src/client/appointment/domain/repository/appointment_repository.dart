import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentModel>>> listAppointments({
    required String authToken,
    String? filter,
  });

  Future<Either<Failure, List<AppointmentModel>>> listSupplierAppointments({
    required String authToken,
    required int serviceId,
    String status = 'upcoming',
  });

  Future<Either<Failure, AppointmentModel>> getAppointmentDetail({
    required String authToken,
    required int appointmentId,
  });

  Future<Either<Failure, void>> cancelAppointment({
    required String authToken,
    required int appointmentId,
    String? reason,
  });

  Future<Either<Failure, void>> rescheduleAppointment({
    required String authToken,
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
    int? workerId,
  });

  Future<Either<Failure, AppointmentModel>> confirmCashAppointment({
    required String authToken,
    required int appointmentId,
  });

  Future<Either<Failure, void>> rateAppointment({
    required String authToken,
    required int appointmentId,
    required int serviceId,
    required int rating,
    required String comment,
  });
}
