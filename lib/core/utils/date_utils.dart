import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:ponte_glam/config/constant/values_constant.dart';

class AppDateUtils {
  /// The default location used throughout the app (America/Bogota).
  static tz.Location get defaultLocation => tz.getLocation(kDefaultTimezone);

  /// Current time in the app's default timezone (Colombia).
  static tz.TZDateTime now() => tz.TZDateTime.now(defaultLocation);

  /// Convert a UTC [DateTime] received from the API to the local timezone.
  /// Call this immediately after [DateTime.parse()] before any display or
  /// business-logic comparison.
  static tz.TZDateTime fromUtc(DateTime utcDate) =>
      tz.TZDateTime.from(utcDate, defaultLocation);

  /// Convert a UTC [DateTime] to an arbitrary timezone (multi-country support).
  static tz.TZDateTime fromUtcToTz(DateTime utcDate, String tzName) {
    final location = tz.getLocation(tzName);
    return tz.TZDateTime.from(utcDate, location);
  }

  /// Format a [tz.TZDateTime] for display to the user.
  /// Defaults to 'dd/MM/yyyy hh:mm a'.
  static String format(tz.TZDateTime dt,
          {String pattern = 'dd/MM/yyyy hh:mm a'}) =>
      DateFormat(pattern).format(dt);

  /// Serialize a [tz.TZDateTime] to ISO 8601 with timezone offset.
  /// Use this before sending any datetime value to the API.
  /// Example output: "2026-04-14T15:00:00-0500"
  static String toIso8601(tz.TZDateTime dt) => dt.toIso8601String();
}
