import 'package:ponte_glam/src/client/splash/data/datasource/splash_datasource.dart';
import 'package:ponte_glam/src/client/splash/domain/repository/splash_repository.dart';

class SplashImplement extends SplashRepository {
  final SplashDatasource splashDatasource;

  SplashImplement(this.splashDatasource);
}
