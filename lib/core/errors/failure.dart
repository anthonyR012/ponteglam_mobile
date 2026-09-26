import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/shared/core/log/domain/use_case/create_mobile_log.dart';

void throwIfError(bool condition, Failure failure) {
  if (condition) {
    throw failure;
  }
}

void catchError(String description, String source) async {
  if (getIt.isRegistered<CreateMobileLog>()) {
    await getIt<CreateMobileLog>().call(
      description: description,
      source: source,
    );
  }
}

class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class FailureManage {
  AppLocalizations get l10n => getIt<AppLocalizations>();

  FailureManage();
  Failure get connectivity => ConnectivityFailure(l10n.failureConnectivity);
  Failure get emptyField => EmptyFailure(l10n.failureEmptyField);
  Failure get wentWrong => WentWrongFailure(l10n.failureWentWrong);
  Failure server(String message) => ServerFailure(message);
  Failure client(String message) => ClientFailure(message);

  Failure noFound(String message) =>
      NoFoundFailure(l10n.failureNoFound(message));
  Failure missingArgument(String argument) =>
      MissingArgumentFailure(l10n.failureMissingArgument(argument));
  Failure insufficientParameters(String permission) =>
      InsufficientParametersFailure(
          l10n.failureInsufficientPermission(permission));
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}

class ConnectivityFailure extends Failure {
  ConnectivityFailure(super.message);
}

class EmptyFailure extends Failure {
  EmptyFailure(super.message);
}

class WentWrongFailure extends Failure {
  WentWrongFailure(super.message);
}

class MissingArgumentFailure extends Failure {
  MissingArgumentFailure(super.message);
}

class InsufficientParametersFailure extends Failure {
  InsufficientParametersFailure(super.message);
}

class NoFoundFailure extends Failure {
  NoFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class ClientFailure extends Failure {
  ClientFailure(super.message);
}

class WidgetsFailure extends Failure {
  WidgetsFailure(super.message);
}
