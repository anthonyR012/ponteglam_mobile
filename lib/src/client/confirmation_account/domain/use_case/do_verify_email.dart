import 'package:dartz/dartz.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';

class DoVerifyEmail {
  final ConfirmationAccountRepository confirmationAccountRepository;
  DoVerifyEmail(this.confirmationAccountRepository);

  Future<Either<Failure, String>> call(
      {required ParamsDoVerifyEmail params}) async {
    final state = await confirmationAccountRepository.verifyEmail(
        code: params.code, authToken: params.user.token ?? "");
    if (state.isRight()) {
      final statedInserted =
          await params.signInCubit.saveUserCall(params: params.paramsUser);

      if (statedInserted.isLeft()) {
        final Failure? leftValue = statedInserted.fold((l) => l, (r) => null);
        return Left(leftValue!);
      }
    }
    return state;
  }
}

class ParamsDoVerifyEmail {
  final ParamsDoSaveUser paramsUser;
  final SignInCubit signInCubit;
  final String code;
  final UserModel user;

  const ParamsDoVerifyEmail(
      {required this.paramsUser,
      required this.signInCubit,
      required this.code,
      required this.user});
}
