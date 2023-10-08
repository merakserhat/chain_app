import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RoutineModel {
  late String id;
  late Duration duration;
  late String title;
  late String iconPath;
  late Color color;
  late bool showOnPanel;

  RoutineModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.showOnPanel,
  });

  static RoutineModel getBaseRoutine() {
    String id = const Uuid().v1();
    return RoutineModel(
      id: id,
      duration: const Duration(hours: 1),
      title: "Football",
      iconPath: "assets/images/icons/football.png",
      color: AppColors.green,
      showOnPanel: true,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['duration'] = duration.inMinutes;
    _data['title'] = title;
    _data['iconPath'] = iconPath;
    _data['color'] = color.value.toString();
    _data['showOnPanel'] = showOnPanel;
    return _data;
  }

  RoutineModel.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    duration = Duration(minutes: json['duration']);
    title = json['title'];
    iconPath = json['iconPath'];
    color = Color(int.parse(json['color']));
    showOnPanel = json['showOnPanel'];
  }
}
