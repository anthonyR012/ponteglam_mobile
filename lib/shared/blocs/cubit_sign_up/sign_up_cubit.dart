import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final DoSignUp signUpCall;
  String? imageUpload;

  SignUpCubit(this.signUpCall) : super(SignUpInitial());

  void doSignUp({required UserModel user}) async {
    emit(SignUpIsLoading());
    final ParamsDoSignUp params = ParamsDoSignUp(
        user: user,
        signUpCubit: getIt<SignUpCubit>(),
        singInCubit: getIt<SignInCubit>(),
        deviceInfo: getIt<DeviceInfoPlugin>());

    final failureOrUser = await signUpCall(params: params);
    emit(_failureOrSignUp(failureOrUser));
  }

  void resetState() {
    emit(SignUpInitial());
  }

  void setState(SignUpState state) {
    emit(state);
  }

  SignUpState _failureOrSignUp(Either<Failure, UserModel> failureOrUser) {
    return failureOrUser.fold((failure) => SignUpError(failure.message),
        (user) => SignUpGetLoaded(user));
  }
}
