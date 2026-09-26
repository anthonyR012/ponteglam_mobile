import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/shared/model/country_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/src/client/setting/data/implement/setting_api_datasource.dart';
import 'package:ponte_glam/src/client/setting/domain/repository/setting_repository.dart';

class SettingImplement extends SettingRepository {
  final SettingApiDatasourceImplement settingApiDatasource;

  SettingImplement(this.settingApiDatasource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      List<CategoryModel> categories =
          await settingApiDatasource.getCategories();
      return Right(categories);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TypeModel>>> getTypes() async {
    try {
      List<TypeModel> types = await settingApiDatasource.getTypes();
      return Right(types);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CityModel>>> getCities(
      {required int countryId}) async {
    try {
      List<CityModel> cities =
          await settingApiDatasource.getCities(countryId: countryId);
      return Right(cities);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CountryModel>>> getCountries() async {
    try {
      List<CountryModel> countries = await settingApiDatasource.getCountries();
      return Right(countries);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getImageByPath(
      {required String imageUrl}) async {
    try {
      List<int> bytes =
          await settingApiDatasource.getImageByPath(imageUrl: imageUrl);
      return Right(bytes);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AmenityModel>>> getAmenities() async {
    try {
      List<AmenityModel> amenities = await settingApiDatasource.getAmenities();
      return Right(amenities);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AmenityModel>>> getAmenitiesByIds(
      {required List<int> ids}) async {
    try {
      List<AmenityModel> amenities =
          await settingApiDatasource.getAmenitiesByIds(ids: ids);
      return Right(amenities);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TypeModel>>> getTypesByCategory(
      {required String category}) async {
    try {
      List<TypeModel> types =
          await settingApiDatasource.getTypesByCategory(category: category);
      return Right(types);
    } catch (e, stackTrace) {
      if (e is! Failure) {
        catchError(e.toString(), stackTrace.toString());
      }
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
