abstract class ConfirmationAccountDatasource {
  Future<String> verifyEmail({required String code, required String authToken});
  Future<String> resendEmail({required String authToken});
}
