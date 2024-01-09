import 'dart:math';
import 'dart:ui';

import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/utils/id_util.dart';

class ActivityModel {
  late int id;
  late Duration time;
  late Duration duration;
  late DateTime date;
  late String title;
  late String iconPath;
  late Color color;
  late bool fromTemplate;
  late bool isDone;
  late String? chainId;
  late String? habitId;
  late int? templateId;
  late List<ReminderModel> reminders;

  ActivityModel({
    required this.id,
    required this.time,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.reminders,
    required this.date,
    this.isDone = false,
    this.fromTemplate = false,
    this.chainId,
    this.habitId,
    this.templateId,
  });

  static ActivityModel getBaseActivity() {
    int id = IdUtil.generateIntId();
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
      title: id.toString(),
      date: DateTime.now(),
      iconPath: "",
      color: color,
      reminders: [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time.inMinutes;
    data['duration'] = duration.inMinutes;
    data['title'] = title;
    data['iconPath'] = iconPath;
    data['color'] = color.value.toString();
    data['fromTemplate'] = fromTemplate;
    data['isDone'] = isDone;
    data['chainId'] = chainId;
    data['habitId'] = habitId;
    data['templateId'] = templateId;
    data['date'] = date.toString();
    data['reminders'] = reminders.map((e) => e.toJson()).toList();
    return data;
  }

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = Duration(minutes: json['time']);
    duration = Duration(minutes: json['duration']);
    title = json['title'];
    iconPath = json['iconPath'];
    color = Color(int.parse(json['color']));
    fromTemplate = json['fromTemplate'];
    isDone = json['isDone'];
    chainId = json['chainId'];
    habitId = json['habitId'];
    templateId = json['templateId'];
    date = DateTime.parse(json['date']).toLocal();
    reminders = List.from(json["reminders"])
        .map((e) => ReminderModel.fromJson(e))
        .toList();
  }
}
