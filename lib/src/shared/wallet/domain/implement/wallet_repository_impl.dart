import 'package:dartz/dartz.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/device/storage/istorage.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/src/shared/wallet/data/datasource/wallet_datasource.dart';
import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';
import 'package:ponte_glam/src/shared/wallet/domain/repository/wallet_repository.dart';

class WalletRepositoryImpl extends WalletRepository {
  WalletRepositoryImpl(this._datasource);
  final WalletApiDatasource _datasource;

  @override
  Future<Either<Failure, WalletModel>> getWallet() async {
    try {
      final IStorage storage = getIt<IStorage>();
      final String authToken = await storage.read(key: keyAuthToken) ?? '';

      final result = await _datasource.getWallet(authToken: authToken);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
