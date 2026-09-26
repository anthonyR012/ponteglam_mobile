import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class DateFormatUtil {
  String getToday() {
    return AppDateUtils.toIso8601(AppDateUtils.now());
  }

  String getCurrentHour() {
    final now = AppDateUtils.now();
    int currentHour = now.hour;
    final int currentMinute = now.minute;
    int hour12 = currentHour > 12 ? currentHour - 12 : currentHour;
    if (hour12 == 0) hour12 = 12;
    String period = currentHour >= 12 ? 'PM' : 'AM';
    final minuteStr = currentMinute.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }

  List<Map<String, String>> getWeekDayShrink(
      int plusDays, BuildContext context) {
    List<Map<String, String>> list = [];
    final today = AppDateUtils.now();
    for (int i = 0; i < plusDays; i++) {
      final date = today.add(Duration(days: i));
      Locale myLocale = Localizations.localeOf(context);
      final dayWeek = DateFormat.EEEE(myLocale.toLanguageTag())
          .format(date)
          .substring(0, 3);
      final dayNumber = today.add(Duration(days: i)).day;
      list.add({
        'dayWeek': dayWeek,
        'dayNumber': dayNumber.toString(),
        'id': i.toString()
      });
    }
    return list;
  }

  String tFormatToHout(String date) {
    final dateTime = AppDateUtils.fromUtc(DateTime.parse(date));
    int currentHour = dateTime.hour;
    final int currentMinute = dateTime.minute;
    int hour12 = currentHour > 12 ? currentHour - 12 : currentHour;
    if (hour12 == 0) hour12 = 12;
    String period = currentHour >= 12 ? 'PM' : 'AM';
    final minuteStr = currentMinute.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }


  String getDateLabelNotification(DateTime date, DateTime now) {
    
    if (isSameDay(date, now)) {
      return getIt<AppLocalizations>().titleToday;
    } else if (isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return getIt<AppLocalizations>().titleYesterday;
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
