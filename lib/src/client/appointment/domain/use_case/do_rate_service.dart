import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

class RateServiceParams {
  final int appointmentId;
  final int serviceId;
  final int rating;
  final String comment;

  RateServiceParams({
    required this.appointmentId,
    required this.serviceId,
    required this.rating,
    this.comment = '',
  });
}

class DoRateService {
  final AppointmentRepository repository;

  DoRateService({required this.repository});

  Future<Either<Failure, void>> call(RateServiceParams params) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    if (authToken.isEmpty) {
      return Left(Failure('No token found'));
    }
    return repository.rateAppointment(
      authToken: authToken,
      appointmentId: params.appointmentId,
      serviceId: params.serviceId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}
