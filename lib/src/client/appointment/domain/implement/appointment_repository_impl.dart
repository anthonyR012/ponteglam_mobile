import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/client/appointment/data/datasource/appointment_datasource.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/domain/repository/appointment_repository.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  AppointmentRepositoryImpl(this._datasource);
  final AppointmentDatasource _datasource;

  @override
  Future<Either<Failure, List<AppointmentModel>>> listAppointments({
    required String authToken,
    String? filter,
  }) async {
    try {
      final result = await _datasource.listAppointments(
          authToken: authToken, filter: filter);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> listSupplierAppointments({
    required String authToken,
    required int serviceId,
    String status = 'upcoming',
  }) async {
    try {
      final result = await _datasource.listSupplierAppointments(
          authToken: authToken, serviceId: serviceId, status: status);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentDetail({
    required String authToken,
    required int appointmentId,
  }) async {
    try {
      final result = await _datasource.getAppointmentDetail(
          authToken: authToken, appointmentId: appointmentId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment({
    required String authToken,
    required int appointmentId,
    String? reason,
  }) async {
    try {
      await _datasource.cancelAppointment(
          authToken: authToken, appointmentId: appointmentId, reason: reason);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rescheduleAppointment({
    required String authToken,
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
    int? workerId,
  }) async {
    try {
      await _datasource.rescheduleAppointment(
        authToken: authToken,
        appointmentId: appointmentId,
        newStartTime: newStartTime,
        newEndTime: newEndTime,
        workerId: workerId,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> confirmCashAppointment({
    required String authToken,
    required int appointmentId,
  }) async {
    try {
      final result = await _datasource.confirmCashAppointment(
          authToken: authToken, appointmentId: appointmentId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rateAppointment({
    required String authToken,
    required int appointmentId,
    required int serviceId,
    required int rating,
    required String comment,
  }) async {
    try {
      await _datasource.rateAppointment(
        authToken: authToken,
        appointmentId: appointmentId,
        serviceId: serviceId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
