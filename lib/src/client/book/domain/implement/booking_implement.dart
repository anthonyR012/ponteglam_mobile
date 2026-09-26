import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/src/client/book/data/datasource/booking_datasource.dart';
import 'package:ponte_glam/src/client/book/data/model/create_appointment_response.dart';
import 'package:ponte_glam/src/client/book/domain/repository/booking_repository.dart';

class BookingImplement extends BookingRepository {
  BookingImplement(this._bookingDatasource);
  final BookingDatasource _bookingDatasource;

  @override
  Future<Either<Failure, CreateAppointmentResponse>> createAppointment({
    required String authToken,
    required int serviceId,
    required int workerId,
    required String startTime,
    required String endTime,
    String paymentMethod = 'card',
    bool isHomeService = false,
    int? homeAddressId,
    List<int>? addonIds,
  }) async {
    try {
      final response = await _bookingDatasource.createAppointment(
        authToken: authToken,
        serviceId: serviceId,
        workerId: workerId,
        startTime: startTime,
        endTime: endTime,
        paymentMethod: paymentMethod,
        isHomeService: isHomeService,
        homeAddressId: homeAddressId,
        addonIds: addonIds,
      );
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableDateModel>>> getAvailableDates({
    required String authToken,
    required int serviceId,
    int? workerId,
    int? headQuarterId,
    int days = 15,
  }) async {
    try {
      final dates = await _bookingDatasource.getAvailableDates(
        authToken: authToken,
        serviceId: serviceId,
        workerId: workerId,
        headQuarterId: headQuarterId,
        days: days,
      );
      return Right(dates);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
