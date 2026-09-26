import 'package:ponte_glam/src/client/sign_up/domain/repository/terms_repository.dart';

class DoAcceptTerms {
  final TermsRepository _repository;

  DoAcceptTerms(this._repository);

  Future<void> call({required int userId, required String token}) async {
    await _repository.acceptTerms(userId: userId, token: token);
  }
}
