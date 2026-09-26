import 'package:ponte_glam/src/client/sign_up/domain/repository/terms_repository.dart';

class GetLegalContent {
  final TermsRepository _repository;

  GetLegalContent(this._repository);

  Future<String> call(String typeCode) async {
    return await _repository.getLegalContent(typeCode);
  }
}
