import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/task/widgets/task_create_base_item.dart';
import 'package:flutter/material.dart';

class TaskColorPicker extends StatelessWidget {
  TaskColorPicker(
      {Key? key, required this.selectedColor, required this.onSelected})
      : super(key: key);

  final List<Color> colorList = [
    AppColors.red,
    AppColors.green,
    AppColors.blue,
    AppColors.yellow,
    AppColors.purple
  ];

  final Color selectedColor;
  final Function(Color) onSelected;

  @override
  Widget build(BuildContext context) {
    return TaskCreateBaseItem(
        label: "What Color?",
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColors.dark600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: colorList
                .map(
                  (color) => GestureDetector(
                    onTap: () => onSelected(color),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: color),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: selectedColor == color
                                    ? AppColors.dark600
                                    : Colors.transparent,
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
