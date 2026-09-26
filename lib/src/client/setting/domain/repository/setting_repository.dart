import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/shared/model/country_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';

abstract class SettingRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<TypeModel>>> getTypes();
  Future<Either<Failure, List<CityModel>>> getCities({required int countryId});
  Future<Either<Failure, List<CountryModel>>> getCountries();
  Future<Either<Failure, List<int>>> getImageByPath({required String imageUrl});
  Future<Either<Failure, List<AmenityModel>>> getAmenities();
  Future<Either<Failure, List<AmenityModel>>> getAmenitiesByIds(
      {required List<int> ids});
  Future<Either<Failure, List<TypeModel>>> getTypesByCategory(
      {required String category});
}
