import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/src/client/setting/domain/repository/setting_repository.dart';

class DoGetAmenities {
  final SettingRepository settingRepository;

  DoGetAmenities(this.settingRepository);

  Future<Either<Failure, List<AmenityModel>>> call(
      {List<int> idAmenities = const []}) async {
    if (idAmenities.isNotEmpty) {
      return await settingRepository.getAmenitiesByIds(ids: idAmenities);
    }
    return await settingRepository.getAmenities();
  }
}
