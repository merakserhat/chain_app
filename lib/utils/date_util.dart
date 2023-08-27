import 'package:intl/intl.dart';

class DateUtil {
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
    if (minimize) {
      String hour = duration.inHours.toString();
      String minute = (duration.inMinutes % 60).toString();

      if (hour == "0") {
        return "${minute}m";
      } else if (minute == "0") {
        return "${hour}h";
      } else {
        return "${hour}h\n${minute}m";
      }
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

  static DateTime calculateCurrentDateTime(int weekIndex, int dayIndex) {
    DateTime today = DateTime.now();
    int incrementDay = dayIndex;
    print(incrementDay);
    return today.add(Duration(days: (7 * weekIndex) + incrementDay));
  }
}
