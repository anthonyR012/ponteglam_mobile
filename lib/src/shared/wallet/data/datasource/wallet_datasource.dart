import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';

abstract class WalletApiDatasource {
  Future<WalletModel> getWallet({required String authToken});
}
