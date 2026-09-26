import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/recover_password/domain/use_case/do_send_email.dart';
import 'package:ponte_glam/src/client/recover_password/domain/use_case/do_update_pass.dart';
import 'package:ponte_glam/src/client/recover_password/domain/use_case/do_verify_code.dart';
import 'package:ponte_glam/shared/blocs/cubit_sing_in/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'recover_state.dart';

class RecoverCubit extends Cubit<RecoverState> {
  RecoverCubit(this.recoverSendEmailCall, this.recoverVerifyCodeCall,
      this.updatePasswordCall)
      : super(RecoverInitial());
  final DoRecoverSendEmail recoverSendEmailCall;
  final DoRecoverVerifyCode recoverVerifyCodeCall;
  final DoUpdatePassword updatePasswordCall;

  void doSendEmail({required String email}) async {
    emit(RecoverIsLoading());
    final failureOrSuccess = await recoverSendEmailCall(email: email);
    emit(_failureOrEmailSended(failureOrSuccess));
  }

  void doVerifyCode({required String code, required String email}) async {
    emit(RecoverIsLoading());
    final failureOrSuccess =
        await recoverVerifyCodeCall(code: code, email: email);
    emit(_failureOrCodeVerified(failureOrSuccess));
  }

  void doUpdatePassword({required UserModel user}) async {
    emit(RecoverIsLoading());
    ParamsDoUpdatePassword params = ParamsDoUpdatePassword(
        user: user,
        prefs: getIt<SharedPreferences>(),
        storage: getIt<IStorage>(),
        saveUserCall: getIt<SignInCubit>().saveUserCall);
    final failureOrSuccess = await updatePasswordCall(params: params);
    emit(_failureOrGetRecover(failureOrSuccess));
  }

  void resetState() {
    emit(RecoverInitial());
  }

  void setState(RecoverState state) {
    emit(state);
  }

  RecoverState _failureOrCodeVerified(
      Either<Failure, UserModel> failureOrCodeVerified) {
    return failureOrCodeVerified.fold(
        (failure) => RecoverError(failure.message),
        (user) => CodeVerified(user));
  }

  RecoverState _failureOrGetRecover(
      Either<Failure, String> failureOrRecoverPass) {
    return failureOrRecoverPass.fold((failure) => RecoverError(failure.message),
        (message) => RecoverPassGetLoaded(message));
  }

  RecoverState _failureOrEmailSended(
      Either<Failure, String> failureOrEmailSended) {
    return failureOrEmailSended.fold((failure) => RecoverError(failure.message),
        (message) => EmailSended(message));
  }
}
