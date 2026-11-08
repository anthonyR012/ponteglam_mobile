import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

/// Mueve la cita a un slot disponible; la hora fin la calcula el backend.
class DoRescheduleAppointment {
  final AppointmentRepository repository;
  DoRescheduleAppointment({required this.repository});

  Future<Either<Failure, void>> call(RescheduleParams params) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    return repository.rescheduleAppointment(
      authToken: authToken,
      appointmentId: params.appointmentId,
      newStartTime: params.newStartTime,
    );
  }
}

class RescheduleParams extends Equatable {
  final int appointmentId;
  final String newStartTime;

  const RescheduleParams({
    required this.appointmentId,
    required this.newStartTime,
  });

  @override
  List<Object?> get props => [appointmentId, newStartTime];
}
