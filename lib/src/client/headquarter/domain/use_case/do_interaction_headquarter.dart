import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/src/client/headquarter/domain/repository/headquarter_repository.dart';

class DoInteractionHeadquarter {
  final HeadquarterRepository headquarterRepository;
  DoInteractionHeadquarter(this.headquarterRepository);

  Future<Either<Failure, String>> call(
      {required ParamsDoInteractionHeadquarter params}) async {
    final token = await params.storage.read(key: keyAuthToken) ?? "";
    if (params.interaction == Interaction.like) {
      return await headquarterRepository.like(
          authToken: token, headquarterCompanyId: params.headquarterCompanyId);
    } else {
      return await headquarterRepository.dislike(
          authToken: token, headquarterCompanyId: params.headquarterCompanyId);
    }
  }
}

class ParamsDoInteractionHeadquarter {
  final int headquarterCompanyId;
  final Interaction interaction;
  final IStorage storage;
  ParamsDoInteractionHeadquarter(
      {required this.headquarterCompanyId,
      required this.interaction,
      required this.storage});
}
