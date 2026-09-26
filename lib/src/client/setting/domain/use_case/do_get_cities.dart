import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/src/client/setting/domain/repository/setting_repository.dart';

class DoGetCities {
  final SettingRepository settingRepository;

  DoGetCities(this.settingRepository);

  Future<Either<Failure, List<CityModel>>> call(
      {required int countryId}) async {
    return await settingRepository.getCities(countryId: countryId);
  }
}
