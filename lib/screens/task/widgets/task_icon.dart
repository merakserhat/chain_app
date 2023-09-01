import 'package:chain_app/constants/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class TaskIconData extends Equatable {
  static const TaskIconData sports =
      TaskIconData("assets/images/chain.png", "sports");
  static const TaskIconData study =
      TaskIconData("assets/images/chain.png", "study");
  static const TaskIconData meal =
      TaskIconData("assets/images/chain.png", "meal");
  static const TaskIconData football =
      TaskIconData("assets/images/chain.png", "football");
  static const TaskIconData kitchen =
      TaskIconData("assets/images/chain.png", "kitchen");
  static const TaskIconData read =
      TaskIconData("assets/images/chain.png", "read");
  static const TaskIconData film =
      TaskIconData("assets/images/chain.png", "film");
  static const TaskIconData coffee =
      TaskIconData("assets/images/chain.png", "coffee");
  static const TaskIconData school =
      TaskIconData("assets/images/chain.png", "school");

  static List<TaskIconData> getFavTaskIcons(int size) {
    return [sports, study, meal, football, kitchen, read, film, coffee, school]
        .sublist(0, size);
  }

  final String src;
  final String name;
  const TaskIconData(this.src, this.name);

  @override
  List<Object> get props => [name];
}

class TaskIcon extends StatelessWidget {
  const TaskIcon({
    Key? key,
    required this.iconData,
    this.othersButton = false,
    this.selected = false,
    required this.onSelected,
  }) : super(key: key);

  final TaskIconData iconData;
  final bool othersButton;
  final bool selected;
  final Function(TaskIconData) onSelected;

  static const double size = 52;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(iconData),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: othersButton
              ? Colors.transparent
              : selected
                  ? AppColors.primary
                  : AppColors.dark600,
        ),
        child: Center(
          child: SizedBox(
            width: size - 24,
            height: size - 24,
            child: Image.asset(iconData.src),
          ),
        ),
      ),
    );
  }
}
