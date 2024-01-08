import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/task/widgets/task_create_base_item.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TaskDurationPicker extends StatelessWidget {
  const TaskDurationPicker(
      {Key? key,
      required this.selectedDuration,
      required this.selectedColor,
      required this.onSelected})
      : super(key: key);

  final Duration selectedDuration;
  final Color selectedColor;
  final Function(Duration) onSelected;
  final double height = 100, padding = 8;

  @override
  Widget build(BuildContext context) {
    return TaskCreateBaseItem(
      label: "How long?",
      child: LayoutBuilder(builder: (context, constraints) {
        Offset topSize = _getDurationBackgroundSize(
            selectedDuration, constraints.maxWidth, false);

        Offset bottomSize = _getDurationBackgroundSize(
            selectedDuration, constraints.maxWidth, true);
        return Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColors.dark600),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Row(
                    children: List.generate(6, (index) {
                      Duration duration = Duration(minutes: (index + 1) * 30);
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelected(duration),
                          child: Center(
                            child: Text(
                              DateUtil.getDurationText(duration,
                                  minimize: true),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    }),
                  )),
                  Expanded(
                      child: Row(
                    children: List.generate(6, (index) {
                      Duration duration =
                          Duration(minutes: 180 + (index + 1) * 30);
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelected(duration),
                          child: Center(
                            child: Text(
                              DateUtil.getDurationText(duration,
                                  minimize: true),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    }),
                  )),
                ],
              ),
              IgnorePointer(
                ignoring: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: topSize.dx > 1000 ? 0 : topSize.dx,
                  height: topSize.dy,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      topRight: const Radius.circular(8),
                      bottomLeft: Radius.circular(bottomSize.dy != 0 ? 0 : 8),
                      bottomRight: Radius.circular(bottomSize.dy != 0 ? 0 : 8),
                    ),
                    color: selectedColor.withOpacity(0.4),
                  ),
                ),
              ),
              Positioned(
                top: (height - 2 * padding) / 2,
                child: IgnorePointer(
                  ignoring: true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: bottomSize.dx > 1000 ? 0 : bottomSize.dx,
                    height: bottomSize.dy,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: selectedColor.withOpacity(0.4),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Offset _getDurationBackgroundSize(
      Duration duration, double panelWidth, bool bottom) {
    double boxHeight = (height - (2 * padding)) / 2;
    double boxWidth = (panelWidth - (2 * padding)) / 6;

    int minutes = duration.inMinutes;
    double y = 0, x = 0;
    if (duration.inMinutes > 180) {
      minutes -= 180;
      y += boxHeight;

      if (bottom) {
        x = (minutes / 30) * boxWidth;
      } else {
        x = 6 * boxWidth;
      }

      return Offset(x, y);
    } else if (bottom) {
      return const Offset(0, 0);
    }
    y += boxHeight;
    x = (minutes / 30) * boxWidth;

    return Offset(x, y);
  }
}
