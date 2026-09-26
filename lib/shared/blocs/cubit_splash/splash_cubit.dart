import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.initAppCall) : super(SplashInitial());
  final DoInitApp initAppCall;
  

  Future<void> doInitApp({required BuildContext context}) async {
    if (state is SplashInitial) {
      emit(SplashIsLoading());
      final failureOrSuccess = await initAppCall(context: context);
      emit(_failureOrState(failureOrSuccess));
    } else if (state is FistTimeInit) {
      emit(SplashInitCompleted());
    } else {
      emit(state);
    }
  }

  SplashState _failureOrState(Either<Failure, SplashState> failureOrSuccess) {
    return failureOrSuccess.fold(
      (failure) => SplashError(failure.message),
      (success) => success,
    );
  }

  void resetState() {
    emit(SplashInitial());
  }

}
