import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';

class DoGetAmenities {
  final SettingRepository settingRepository;

  DoGetAmenities(this.settingRepository);

  Future<Either<Failure, AmenityModel>> call(
      {required Repository dataFrom}) async {
    return Right(AmenityModel.empty());
  }
}
