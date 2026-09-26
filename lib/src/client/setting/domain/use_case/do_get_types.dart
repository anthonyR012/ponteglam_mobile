import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/src/client/setting/domain/repository/setting_repository.dart';

class DoGetTypes {
  final SettingRepository settingRepository;

  DoGetTypes(this.settingRepository);

  Future<Either<Failure, List<TypeModel>>> call() async {
    return await settingRepository.getTypes();
  }
}
