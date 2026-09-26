import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

class DoCancelAppointment {
  final AppointmentRepository repository;
  DoCancelAppointment({required this.repository});

  Future<Either<Failure, void>> call(
      {required int appointmentId, String? reason}) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    return repository.cancelAppointment(
        authToken: authToken, appointmentId: appointmentId, reason: reason);
  }
}
