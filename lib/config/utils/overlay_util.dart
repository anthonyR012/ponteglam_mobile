
import 'package:flutter/material.dart';
import 'package:ponte_glam/shared/widgets/background_overlay_widget.dart';

class OverlayController {
  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;
  final GlobalKey<BackgroundOverlayWidgetState> _key = GlobalKey();
  bool _isOverlayShown = false;

  void initOverlay(
      {required BuildContext context,
      required VoidCallback onDismiss,
      required double width,
      required Widget child}) {
    _overlayEntry = OverlayEntry(builder: (context) {
      return BackgroundOverlayWidget(
          buildContext: context,
          onDismiss: onDismiss,
          key: _key,
          child: SizedBox(
            width: width,
            child: child,
          ));
    });
    _overlayState = Overlay.of(context);
  }

  void show() {
    assert(_overlayEntry != null, "overlay not initialized");
    if (_isOverlayShown) {
      return;
    }
    _overlayState!.insert(_overlayEntry!);
    _isOverlayShown = true;
  }

  void showFor({required int seconds}) {
    assert(seconds > 0, "seconds must be greater than 0");
    if (_isOverlayShown) {
      return;
    }
    show();
    Future.delayed(Duration(seconds: seconds), () => hide());
  }

  void hide() {
    if(_overlayEntry == null || !_isOverlayShown) return;

    _isOverlayShown = false;
    assert(_key.currentState != null, "key.currentState is null");
    _key.currentState!.controller.reverse();
    Future.delayed(Durations.long1, () {
      _overlayEntry!.remove();
    });
  }

  void toggle() {
    if (_isOverlayShown) {
      hide();
    } else {
      show();
    }
  }
}