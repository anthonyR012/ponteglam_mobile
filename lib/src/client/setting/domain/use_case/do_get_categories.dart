import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/src/client/setting/domain/repository/setting_repository.dart';

class DoGetCategories {
  final SettingRepository settingRepository;

  DoGetCategories(this.settingRepository);

  Future<Either<Failure, List<CategoryModel>>> call() async {
    return await settingRepository.getCategories();
  }
}
