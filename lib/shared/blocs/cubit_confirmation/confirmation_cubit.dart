import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
part 'confirmation_state.dart';

class ConfirmationCubit extends Cubit<ConfirmationState> {
  ConfirmationCubit(this.verifyEmailCall, this.resendEmailCall)
      : super(ConfirmationInitial());

  final DoVerifyEmail verifyEmailCall;
  final DoResendEmail resendEmailCall;

  void doResendEmail({required String authToken}) async {
    emit(ConfirmationIsLoading());
    final failureOrResend = await resendEmailCall(authToken: authToken);
    emit(_failureOrResendEmail(failureOrResend));
  }

  void doVerifyEmail({required String code, required UserModel user}) async {
    emit(ConfirmationIsLoading());
    final ParamsDoVerifyEmail params = ParamsDoVerifyEmail(
        code: code,
        user: user,
        paramsUser: ParamsDoSaveUser(
            prefs: getIt<SharedPreferences>(),
            storage: getIt<IStorage>(),
            user: user,
            dataFrom: Repository.local),
        signInCubit: getIt<SignInCubit>());
    final failureOrUser = await verifyEmailCall(params: params);
    emit(_failureOrConfirmation(failureOrUser));
  }

  void resetState() {
    emit(ConfirmationInitial());
  }

  void setState(ConfirmationState state) {
    emit(state);
  }

  ConfirmationState _failureOrResendEmail(
      Either<Failure, String> failureOrResend) {
    return failureOrResend.fold((failure) => ConfirmationError(failure.message),
        (message) => ResendEmilLoaded(message));
  }

  ConfirmationState _failureOrConfirmation(
      Either<Failure, String> failureOrSuccessMessage) {
    return failureOrSuccessMessage.fold(
        (failure) => ConfirmationError(failure.message),
        (message) => ConfirmationGetLoaded(message));
  }
}
