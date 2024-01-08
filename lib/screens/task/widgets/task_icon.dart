import 'package:chain_app/constants/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class TaskIconData extends Equatable {
  static const TaskIconData sports = TaskIconData(
    "assets/images/icons/dumbel.png",
    "Sports",
  );
  static const TaskIconData study =
      TaskIconData("assets/images/icons/pen.png", "Study");
  static const TaskIconData meal =
      TaskIconData("assets/images/icons/food.png", "Meal");
  static const TaskIconData football =
      TaskIconData("assets/images/icons/football.png", "Football");
  static const TaskIconData kitchen =
      TaskIconData("assets/images/icons/cooking.png", "Kitchen");
  static const TaskIconData read =
      TaskIconData("assets/images/chain.png", "Read");
  static const TaskIconData film =
      TaskIconData("assets/images/chain.png", "Film");
  static const TaskIconData coffee =
      TaskIconData("assets/images/chain.png", "Coffee");
  static const TaskIconData school =
      TaskIconData("assets/images/chain.png", "School");

  static List<TaskIconData> taskIcons = [
    sports,
    study,
    meal,
    football,
    kitchen,
    read,
    film,
    coffee,
    school
  ];

  static List<TaskIconData> getFavTaskIcons(int size) {
    return taskIcons.sublist(0, size);
  }

  static TaskIconData? getTaskIconWithPath(String? path) {
    try {
      return taskIcons.firstWhere((element) => element.src == path);
    } catch (_) {
      return null;
    }
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
    this.panel = false,
    required this.selectedColor,
  }) : super(key: key);

  final TaskIconData iconData;
  final bool othersButton;
  final bool panel;
  final bool selected;
  final Function(TaskIconData) onSelected;
  final Color selectedColor;

  static const double size = 52;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(iconData);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: othersButton
              ? Colors.transparent
              : selected
                  ? selectedColor
                  : AppColors.dark600,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              iconData.src,
              color: panel ? selectedColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
