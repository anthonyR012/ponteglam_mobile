import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/shared/wallet/domain/repository/wallet_repository.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository repository;

  WalletCubit({required this.repository}) : super(const WalletState());

  Future<void> loadWallet() async {
    emit(state.copyWith(status: WalletStatus.loading));

    final result = await repository.getWallet();

    result.fold(
      (failure) => emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: failure.message,
      )),
      (wallet) => emit(state.copyWith(
        status: WalletStatus.success,
        wallet: wallet,
      )),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: WalletStatus.success));
  }
}
