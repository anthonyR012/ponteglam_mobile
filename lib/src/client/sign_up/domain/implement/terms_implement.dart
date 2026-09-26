import 'package:ponte_glam/src/client/sign_up/data/datasource/terms_datasource.dart';
import 'package:ponte_glam/src/client/sign_up/domain/repository/terms_repository.dart';

class TermsImplement extends TermsRepository {
  final TermsDatasource _datasource;

  TermsImplement(this._datasource);

  @override
  Future<void> acceptTerms({required int userId, required String token}) async {
    try {
      await _datasource.acceptTerms(userId: userId, token: token);
    } catch (_) {
      // fail silently — T&C acceptance is best-effort after registration
    }
  }

  @override
  Future<String> getLegalContent(String typeCode) async {
    return await _datasource.getLegalContent(typeCode);
  }
}
