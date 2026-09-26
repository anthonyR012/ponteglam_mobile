abstract class TermsDatasource {
  Future<void> acceptTerms({required int userId, required String token});
  Future<String> getLegalContent(String typeCode);
}
