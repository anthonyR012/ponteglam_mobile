import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/shared/model/country_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';

abstract class SettingDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<List<TypeModel>> getTypes();
  Future<List<AmenityModel>> getAmenities();
  Future<List<TypeModel>> getTypesByCategory({required String category});
  Future<List<AmenityModel>> getAmenitiesByIds({required List<int> ids});
  Future<List<CityModel>> getCities({required int countryId});
  Future<List<int>> getImageByPath({required String imageUrl});
  Future<List<CountryModel>> getCountries();
}
