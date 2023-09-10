import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:uuid/uuid.dart';

class TemplateModel extends RoutineModel {
  final Duration time;

  TemplateModel({
    required this.time,
    required super.id,
    required super.duration,
    required super.title,
    required super.iconPath,
    required super.color,
    required super.showOnPanel,
  });

  static TemplateModel getBaseRoutine() {
    String id = const Uuid().v1();
    return TemplateModel(
      time: const Duration(hours: 14),
      showOnPanel: false,
      id: id,
      duration: const Duration(hours: 1),
      title: "Football",
      iconPath: "assets/images/icons/football.png",
      color: AppColors.green,
    );
  }
}
