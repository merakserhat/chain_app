import 'dart:math';
import 'dart:ui';

import 'package:uuid/uuid.dart';

class ActivityModel {
  String id;
  Duration time;
  Duration duration;
  String title;
  String iconPath;
  Color color;
  String? chainId;
  String? habitId;

  ActivityModel({
    required this.id,
    required this.time,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    this.chainId,
    this.habitId,
  });

  static ActivityModel getBaseActivity() {
    String id = const Uuid().v1();
    Color color = Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1.0,
    );
    return ActivityModel(
      id: id,
      time: Duration(hours: 10),
      duration: Duration(hours: 1),
      title: id,
      iconPath: "",
      color: color,
    );
  }
}
