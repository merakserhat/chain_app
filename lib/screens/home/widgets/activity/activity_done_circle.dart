import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class ActivityDoneCircle extends StatelessWidget {
  const ActivityDoneCircle({
    super.key,
    required this.isDone,
    required this.color,
    required this.onStatusChanged,
  });

  final bool isDone;
  final Color color;
  final Function(bool) onStatusChanged;

  final double size = 20;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onStatusChanged(!isDone),
      child: Container(
        padding: const EdgeInsets.all(2),
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: color),
        child: Container(
          padding: const EdgeInsets.all(2),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.dark600),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isDone ? color : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
