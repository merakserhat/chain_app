import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:flutter/material.dart';

class RoutineCircle extends StatelessWidget {
  const RoutineCircle(
      {Key? key, required this.hourHeight, required this.routine})
      : super(key: key);

  final double hourHeight;
  final RoutineModel routine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: hourHeight,
      height: hourHeight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: AppColors.dark500),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Image.asset(
          routine.iconPath,
          color: routine.color,
        ),
      ),
    );
  }
}
