class PonteLocationServiceDisabledException implements Exception {
  final String message;
  PonteLocationServiceDisabledException([this.message = 'Service disabled']);
  @override
  String toString() => message;
}

class PonteLocationPermissionDeniedException implements Exception {
  final String message;
  PonteLocationPermissionDeniedException([this.message = 'Permission denied']);
  @override
  String toString() => message;
}
