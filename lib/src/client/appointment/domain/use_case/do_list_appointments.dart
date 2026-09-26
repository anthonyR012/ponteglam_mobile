import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

class DoListAppointments {
  final AppointmentRepository repository;
  DoListAppointments({required this.repository});

  Future<Either<Failure, List<AppointmentModel>>> call({String? filter}) async {
    final IStorage storage = getIt<IStorage>();
    final String authToken = await storage.read(key: keyAuthToken) ?? '';
    return repository.listAppointments(authToken: authToken, filter: filter);
  }
}
