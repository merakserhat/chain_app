import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/utils/id_util.dart';
import 'package:uuid/uuid.dart';

class TemplateModel {
  late List<List<Duration>> durations;
  late int id;
  late Duration duration;
  late String title;
  late String iconPath;
  late Color color;
  late bool showOnPanel;
  late List<ReminderModel> reminders;

  TemplateModel({
    required this.durations,
    required this.id,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.showOnPanel,
    required this.reminders,
  });

  static TemplateModel getBaseRoutine() {
    int id = IdUtil.generateIntId();
    return TemplateModel(
      durations: [
        [],
        [],
        [],
        [],
        [],
        [],
        [const Duration(hours: 14), const Duration(hours: 16)]
      ],
      showOnPanel: false,
      id: id,
      duration: const Duration(hours: 1),
      title: "Football",
      iconPath: "assets/images/icons/football.png",
      color: AppColors.green,
      reminders: [],
    );
  }

  TemplateModel.fromJson(Map<String, dynamic> json) {
    List<List<dynamic>> minutes =
        List.castFrom<dynamic, List<dynamic>>(json['durations']);
    durations = minutes
        .map((e) => e.map((minute) => Duration(minutes: minute)).toList())
        .toList();
    showOnPanel = json['showOnPanel'];
    id = json['id'];
    duration = Duration(minutes: json['duration']);
    title = json['title'];
    iconPath = json['iconPath'];
    color = Color(int.parse(json['color']));
    reminders = List.from(json["reminders"])
        .map((e) => ReminderModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['durations'] = durations
        .map((e) => e.map((duration) => duration.inMinutes).toList())
        .toList();
    data['id'] = id;
    data['duration'] = duration.inMinutes;
    data['title'] = title;
    data['iconPath'] = iconPath;
    data['color'] = color.value.toString();
    data['showOnPanel'] = showOnPanel;
    data['reminders'] = reminders.map((e) => e.toJson());
    return data;
  }

  RoutineModel toRoutine() {
    return RoutineModel(
      id: id,
      duration: duration,
      title: title,
      iconPath: iconPath,
      color: color,
      showOnPanel: showOnPanel,
      reminders: reminders,
    );
  }
}
