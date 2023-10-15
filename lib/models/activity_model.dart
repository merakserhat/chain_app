import 'dart:math';
import 'dart:ui';

import 'package:uuid/uuid.dart';

class ActivityModel {
  late String id;
  late Duration time;
  late Duration duration;
  late String title;
  late String iconPath;
  late Color color;
  late String? chainId;
  late String? habitId;
  late String? templateId;

  ActivityModel({
    required this.id,
    required this.time,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    this.chainId,
    this.habitId,
    this.templateId,
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
      time: const Duration(hours: 10),
      duration: const Duration(hours: 1),
      title: id,
      iconPath: "",
      color: color,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['time'] = time.inMinutes;
    _data['duration'] = duration.inMinutes;
    _data['title'] = title;
    _data['iconPath'] = iconPath;
    _data['color'] = color.value.toString();
    _data['chainId'] = chainId;
    _data['habitId'] = habitId;
    _data['templateId'] = templateId;
    return _data;
  }

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = Duration(minutes: json['time']);
    duration = Duration(minutes: json['duration']);
    title = json['title'];
    iconPath = json['iconPath'];
    color = Color(int.parse(json['color']));
    chainId = json['chainId'];
    habitId = json['habitId'];
    templateId = json['templateId'];
  }
}
