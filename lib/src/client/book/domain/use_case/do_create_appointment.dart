import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/book/data/model/create_appointment_response.dart';
import 'package:ponte_glam/src/client/book/domain/repository/booking_repository.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';

class DoCreateAppointment {
  final BookingRepository repository;
  DoCreateAppointment({required this.repository});

  Future<Either<Failure, CreateAppointmentResponse>> call(
      CreateAppointmentParams params) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? "";

    return await repository.createAppointment(
      authToken: authToken,
      serviceId: params.serviceId,
      workerId: params.workerId,
      startTime: params.startTime,
      endTime: params.endTime,
      paymentMethod: params.paymentMethod,
    );
  }
}

class CreateAppointmentParams extends Equatable {
  final int serviceId;
  final int workerId;
  final String startTime;
  final String endTime;
  final String paymentMethod;

  const CreateAppointmentParams({
    required this.serviceId,
    required this.workerId,
    required this.startTime,
    required this.endTime,
    this.paymentMethod = 'card',
  });

  @override
  List<Object?> get props => [serviceId, workerId, startTime, endTime, paymentMethod];
}
