import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/src/client/service/data/datasource/service_datasource.dart';
import 'package:ponte_glam/src/client/setting/data/implement/setting_api_datasource.dart';

class ServiceLocalDatasourceImplement extends ServiceDatasource
    with GetAmenityMixin {
  ServiceLocalDatasourceImplement(this._settingApiDatasource, this._failureMange);

  final SettingApiDatasourceImplement _settingApiDatasource;
  final FailureManage _failureMange;

  @override
  Future<AmenityModel> getAminity({required int amenityId}) async {
    final amenities =
        await _settingApiDatasource.getAmenitiesByIds(ids: [amenityId]);
    if (amenities.isEmpty) {
      throw _failureMange.emptyField;
    }
    return amenities.first;
  }
}
