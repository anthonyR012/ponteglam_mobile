import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';

/// Centralizes navigation triggered by push notification taps.
///
/// Using [router.go] directly inside a notification handler replaces the
/// entire navigation stack with a single route, leaving no parent screen below
/// it.  This helper always rebuilds the full stack:
///   1. [router.go] → base home route (clears and starts fresh)
///   2. addPostFrameCallback → [router.push] → target route
///
/// This produces the expected stack: [home → target].
class NotificationNavigator {
  const NotificationNavigator._();

  /// Navigates to [targetRoute] after resetting to the home base.
  ///
  /// [extra] is forwarded to the target route (e.g. `{'appointmentId': 1}`).
  static void navigate(
    GoRouter router,
    String targetRoute, {
    Object? extra,
  }) {
    // Step 1 — clear the stack and land on home.
    router.go('/${HomePage.routeName}');

    // Step 2 — after the home frame is rendered, push the target on top.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      router.push(targetRoute, extra: extra);
    });
  }
}
