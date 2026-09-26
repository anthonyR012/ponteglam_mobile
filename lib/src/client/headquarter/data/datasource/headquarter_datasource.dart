abstract class HeadquarterDatasource {
  Future<String> like(
      {required String authToken, required int headquarterCompanyId});
  Future<String> dislike(
      {required String authToken, required int headquarterCompanyId});
}
