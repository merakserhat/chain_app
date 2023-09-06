import 'dart:ui';

import 'package:chain_app/constants/app_theme.dart';
import 'package:uuid/uuid.dart';

class RoutineModel {
  String id;
  Duration duration;
  String title;
  String iconPath;
  Color color;

  RoutineModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.iconPath,
    required this.color,
  });

  static RoutineModel getBaseRoutine() {
    String id = const Uuid().v1();
    return RoutineModel(
      id: id,
      duration: const Duration(hours: 1),
      title: "Football",
      iconPath: "assets/images/icons/football.png",
      color: AppColors.green,
    );
  }
}
