import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletModel>> getWallet();
}
