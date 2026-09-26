import 'package:flutter/widgets.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/shared/widgets/alert_overlay_widget.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class AlertManageUtil {
  late final Map<OverlayAlertType, OverlayEntry?> _overlayEntries;
  late final Map<OverlayAlertType, OverlayState?> _overlayStates;
  late Map<OverlayAlertType, bool> _isOverlayShown;

  AlertManageUtil({required BuildContext buildContext}) {
    _overlayEntries = {
      OverlayAlertType.load: OverlayEntry(builder: (context) {
        return AlertOverlayCenter(buildContext: context);
      }),
      OverlayAlertType.snackbar: OverlayEntry(builder: (context) {
        return const SnackBarWidget();
      }),
      OverlayAlertType.tooltip: OverlayEntry(builder: (context) {
        return const SnackBarWidget();
      }),
    };
    _overlayStates = {
      OverlayAlertType.load: Overlay.of(buildContext),
      OverlayAlertType.snackbar: Overlay.of(buildContext),
      OverlayAlertType.tooltip: Overlay.of(buildContext),
    };
    _isOverlayShown = {
      OverlayAlertType.load: false,
      OverlayAlertType.snackbar: false,
      OverlayAlertType.tooltip: false,
    };
  }

  void show({required OverlayAlertType type}) {
    if (_isOverlayShown[type]! || _overlayStates[type] == null) {
      return;
    }
    _overlayStates[type]!.insert(_overlayEntries[type]!);
    _isOverlayShown[type] = true;
  }

  void showFor({required int seconds, required OverlayAlertType type}) {
    assert(seconds > 0, "seconds must be greater than 0");
    if (_isOverlayShown[type]! || _overlayStates[type] == null) {
      return;
    }
    show(type: type);
    Future.delayed(Duration(seconds: seconds), () => hide(type: type));
  }

  void hide({required OverlayAlertType type}) {
    if (!_isOverlayShown[type]! && _overlayEntries[type] == null) {
      return;
    }
    _overlayEntries[type]?.remove();
    _isOverlayShown[type] = false;
  }

  void toggle({required OverlayAlertType type}) {
    if (_isOverlayShown[type]!) {
      hide(type: type);
    } else {
      show(type: type);
    }
  }
}
