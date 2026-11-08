import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

/// Horarios libres del mismo trabajador a los que se puede mover la cita.
class DoListRescheduleSlots {
  DoListRescheduleSlots({required this.repository});
  final AppointmentRepository repository;

  Future<Either<Failure, List<AvailableDateModel>>> call(int appointmentId) async {
    final String authToken =
        await getIt<IStorage>().read(key: keyAuthToken) ?? '';
    return repository.listRescheduleSlots(
      authToken: authToken,
      appointmentId: appointmentId,
    );
  }
}
