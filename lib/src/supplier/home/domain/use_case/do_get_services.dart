import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/geolocator/geolocator_device.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/home/domain/repository/home_repository.dart';

class DoGetServices {
  final HomeRepository homeRepository;
  DoGetServices(this.homeRepository);

  Future<Either<Failure, PaginatorServiceModel>> call(
      {required ParamsDoGetServices params}) async {
    late Position position;
    try {
      position = await params.geoDevice.getCurrentPosition();
    } catch (e) {
      position = Position.fromMap({"latitude": 0.0, "longitude": 0.0});
    }
    final token = await params.storage.read(key: keyAuthToken) ?? "";
    return await homeRepository.getServices(
        authToken: token,
        position: position,
        filter: params.filter);
  }
}

class ParamsDoGetServices {
  final FilterServiceModel filter;
  final GeoDevice geoDevice;
  final IStorage storage;

  ParamsDoGetServices(
      {required this.filter,
      required this.geoDevice,
      required this.storage});
}
