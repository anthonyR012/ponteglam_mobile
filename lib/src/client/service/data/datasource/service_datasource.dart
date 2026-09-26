import 'package:ponte_glam/shared/model/amenity_model.dart';

abstract class ServiceDatasource {}

mixin GetAmenityMixin {
  Future<AmenityModel> getAminity({required int amenityId});
}
