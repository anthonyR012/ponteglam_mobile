import 'package:equatable/equatable.dart';
import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletModel? wallet;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallet,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletModel? wallet,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallet, errorMessage];
}
