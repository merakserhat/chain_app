import 'package:chain_app/constants/app_constants.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static const List<String> days = [
    "Mon",
    "Tue",
    "Wed",
    "Thr",
    "Fri",
    "Sat",
    "Sun"
  ];

  static List<DateTime> getWeekDates(DateTime currentDate) {
    List<DateTime> weekDates = [];
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      weekDates.add(date);
    }

    return weekDates;
  }

  static String getDurationText(Duration duration, {bool minimize = false}) {
    if (duration.inHours >= 24) {
      duration = Duration(minutes: duration.inMinutes % (24 * 60));
    }
    if (minimize) {
      if (duration.inMinutes % 60 == 0) {
        return "${duration.inHours}h";
      }

      return "${duration.inHours},5h";
    }
    return "${duration.inHours.toString().padLeft(2, "0")}:${(duration.inMinutes % 60).toString().padLeft(2, "0")}";
  }

  static String getAbbreviatedWeekday(DateTime date) {
    return DateFormat.E()
        .format(date); // E returns the abbreviated weekday name
  }

  static String getMonthDay(DateTime date) {
    return DateFormat.d()
        .format(date); // E returns the abbreviated weekday name
  }

  static bool isToday(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool inInPanelWeek(DateTime date, List<DateTime> week) {
    for (DateTime weekDay in week) {
      if (isToday(date, weekDay)) {
        return true;
      }
    }

    return false;
  }

  static int indexInList(DateTime date, List<DateTime> dates) {
    int i = 0;
    for (DateTime weekDay in dates) {
      if (isToday(date, weekDay)) {
        return i;
      }
      i++;
    }

    return -1;
  }

  static DateTime calculateCurrentDateTime(int dayIndex) {
    DateTime today = DateTime.now();
    int incrementDay = dayIndex;
    return today.add(Duration(days: incrementDay));
  }

  static int calculateDateWeekIndex(DateTime dateTime) {
    DateTime today = DateTime.now();
    DateTime firstDayOfThisWeek =
        DateTime.now().add(Duration(days: -1 * (today.weekday - 1)));
    DateTime firstDayOfSelectedWeek =
        dateTime.add(Duration(days: -1 * (dateTime.weekday - 1)));

    int dayDifference =
        firstDayOfThisWeek.difference(firstDayOfSelectedWeek).inDays;
    if (dayDifference < 0) {
      dayDifference--;
    }

    return AppConstants.initialWeekIndex - (dayDifference ~/ 7);
  }

  static bool isInBetween(
      {required Duration duration,
      required Duration start,
      required Duration end}) {
    return end.inMinutes > duration.inMinutes &&
        duration.inMinutes > start.inMinutes;
  }
}
