import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

abstract class HomeDatasource {}

mixin GetServicesMixin {
  Future<PaginatorServiceModel> getServices(
      {required String authToken,
      required Position position,
       required FilterServiceModel filter});
}

abstract class HomeApiDatasource extends HomeDatasource with GetServicesMixin {}
