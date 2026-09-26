import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/type_model.dart';

class DoGetTypesByCategory {
  final SettingRepository settingRepository;

  DoGetTypesByCategory(this.settingRepository);

  Future<Either<Failure, List<TypeModel>>> call(
      {required String category}) async {
    return await settingRepository.getTypesByCategory(category: category);
  }
}
