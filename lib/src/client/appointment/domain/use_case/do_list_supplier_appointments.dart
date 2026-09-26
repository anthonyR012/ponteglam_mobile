import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

class DoListSupplierAppointments {
  final AppointmentRepository repository;

  DoListSupplierAppointments(this.repository);

  Future<Either<Failure, List<AppointmentModel>>> call({
    required String authToken,
    required int serviceId,
    String status = 'upcoming',
  }) async {
    return await repository.listSupplierAppointments(
      authToken: authToken,
      serviceId: serviceId,
      status: status,
    );
  }
}
