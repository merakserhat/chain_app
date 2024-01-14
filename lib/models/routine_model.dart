import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/utils/id_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RoutineModel {
  late int id;
  late Duration duration;
  late String title;
  late String iconPath;
  late Color color;
  late bool showOnPanel;
  late List<ReminderModel> reminders;

  RoutineModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.showOnPanel,
    required this.reminders,
  });

  static RoutineModel getBaseRoutine() {
    int id = IdUtil.generateIntId();
    return RoutineModel(
      id: id,
      duration: const Duration(hours: 1),
      title: "Football",
      iconPath: "assets/images/icons/football.png",
      color: AppColors.green,
      showOnPanel: true,
      reminders: [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration.inMinutes;
    data['title'] = title;
    data['iconPath'] = iconPath;
    data['color'] = color.value.toString();
    data['showOnPanel'] = showOnPanel;
    data['reminders'] = reminders.map((e) => e.toJson()).toList();
    return data;
  }

  RoutineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = Duration(minutes: json['duration']);
    title = json['title'];
    iconPath = json['iconPath'];
    color = Color(int.parse(json['color']));
    showOnPanel = json['showOnPanel'];
    reminders = List.from(json["reminders"])
        .map((e) => ReminderModel.fromJson(e))
        .toList();
  }
}
