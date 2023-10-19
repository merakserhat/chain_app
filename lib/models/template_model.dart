import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:uuid/uuid.dart';

class TemplateModel {
  late List<List<Duration>> durations;
  late String id;
  late Duration duration;
  late String title;
  late String iconPath;
  late Color color;
  late bool showOnPanel;

  TemplateModel({
    required this.durations,
    required this.id,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.showOnPanel,
  });

  static TemplateModel getBaseRoutine() {
    String id = const Uuid().v1();
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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['durations'] = durations
        .map((e) => e.map((duration) => duration.inMinutes).toList())
        .toList();
    _data['id'] = id;
    _data['duration'] = duration.inMinutes;
    _data['title'] = title;
    _data['iconPath'] = iconPath;
    _data['color'] = color.value.toString();
    _data['showOnPanel'] = showOnPanel;
    return _data;
  }

  RoutineModel toRoutine() {
    return RoutineModel(
        id: id,
        duration: duration,
        title: title,
        iconPath: iconPath,
        color: color,
        showOnPanel: showOnPanel);
  }
}
