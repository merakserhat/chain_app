import 'dart:math';

import 'package:chain_app/models/activity_model.dart';

class DragModel<E> {
  double height;
  double y;
  ActivityModel activityModel;
  E item;

  DragModel({
    required this.height,
    required this.y,
    required this.item,
    required this.activityModel,
  });

  fixDragModel(double panelHeight, double hourHeight, Duration wakeTime) {
    if (wakeTime.inMinutes > activityModel.time.inMinutes) {
      activityModel.time = wakeTime;
    }
    int distanceDuration = activityModel.time.inMinutes - wakeTime.inMinutes;
    y = roundToNearestMultipleOfHeight(
        (distanceDuration * hourHeight) / 60, hourHeight);
    height = roundToNearestMultipleOfHeight(
        (activityModel.duration.inMinutes * hourHeight) / 60, hourHeight);
  }

  fixActivityModel(double panelHeight, double hourHeight, Duration wakeTime) {
    Duration activityTime =
        findActivityTime(y, panelHeight, hourHeight, wakeTime);
    Duration activityDuration =
        findActivityDuration(height, panelHeight, hourHeight, wakeTime);
    activityModel.duration = activityDuration;
    activityModel.time = activityTime;
    //TODO update db
  }

  static Duration findActivityTime(
      double y, double panelHeight, double hourHeight, Duration wakeTime) {
    int distanceDuration =
        roundToNearestHalfHour((y * 60) / hourHeight).toInt();
    return Duration(minutes: wakeTime.inMinutes + distanceDuration);
  }

  static Duration findActivityDuration(
      double height, double panelHeight, double hourHeight, Duration wakeTime) {
    return Duration(
        minutes: roundToNearestHalfHour((60 * height) / hourHeight).toInt());
  }

  static double roundToNearestHalfHour(double number) {
    double remainder = number % 30;
    if (remainder <= 15) {
      return number - remainder;
    } else {
      return number + (30 - remainder);
    }
  }

  double roundToNearestMultipleOfHeight(double number, double hourHeight) {
    double roundDifference = number % (hourHeight / 2);
    double rounded2 = number - roundDifference;
    if (roundDifference > hourHeight / 4) {
      rounded2 += hourHeight / 2;
    }
    return max(0, rounded2);
  }
}
