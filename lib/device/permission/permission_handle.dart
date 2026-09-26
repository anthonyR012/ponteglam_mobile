import 'package:permission_handler/permission_handler.dart';

class PermissionHandle {
  final List<Permission> _permissionRequired = [
    Permission.location,
  ];

  Future<bool> _hasPermission(Permission permission) async {
    return await permission.isGranted;
  }

  Future<void> _requiredPermission(Permission permission) async {
    await permission.request();
  }

  Future<void> checkPermission() async {
    for (var permission in _permissionRequired) {
      if (!(await _hasPermission(permission))) {
        await _requiredPermission(permission);
      }
    }
  }
}
