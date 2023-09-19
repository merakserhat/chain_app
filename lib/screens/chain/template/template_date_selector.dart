import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/task/widgets/task_create_base_item.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TemplateDateSelector extends StatefulWidget {
  const TemplateDateSelector({Key? key, required this.dateSelectorController})
      : super(key: key);
  final DateSelectorController dateSelectorController;

  @override
  State<TemplateDateSelector> createState() => _TemplateDateSelectorState();
}

class _TemplateDateSelectorState extends State<TemplateDateSelector> {
  List<String> selectedDays = [];
  List<List<Duration>> selectedDurations = [];

  @override
  void initState() {
    super.initState();
    selectedDurations = List.generate(7, (index) => []);
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"];
    widget.dateSelectorController.selectedDurations = selectedDurations;
    return TaskCreateBaseItem(
      label: "Which dates?",
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: days
                  .map((day) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedDays.contains(day)) {
                                  selectedDays.remove(day);
                                  selectedDurations[days.indexOf(day)].clear();
                                } else {
                                  selectedDays.add(day);
                                }
                              });
                            },
                            child: Container(
                              height: 40,
                              width:
                                  (MediaQuery.of(context).size.width - 8 - 24) /
                                      7,
                              padding: const EdgeInsets.all(4),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedDays.contains(day)
                                      ? AppColors.purple.withOpacity(0.2)
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    day,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: AppColors.dark300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 240,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(33, (index) {
                                  Duration duration =
                                      Duration(hours: 8, minutes: index * 30);
                                  int dayIndex = days.indexOf(day);

                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (!selectedDays.contains(day)) {
                                        selectedDays.add(day);
                                      }
                                      List<Duration> selecteds =
                                          selectedDurations[dayIndex];
                                      if (selecteds.length == 2) {
                                        if (selecteds[1].inMinutes <
                                            duration.inMinutes) {
                                          selecteds[1] = duration;
                                        } else if (selecteds[0].inMinutes >
                                            duration.inMinutes) {
                                          selecteds[0] = duration;
                                        } else {
                                          selecteds.clear();
                                          selecteds.add(duration);
                                        }
                                      } else if (selecteds.length == 1) {
                                        if (selecteds[0].inMinutes <
                                            duration.inMinutes) {
                                          selecteds.add(duration);
                                        } else if (selecteds[0].inMinutes >
                                            duration.inMinutes) {
                                          selecteds.add(duration);
                                          selecteds =
                                              selecteds.reversed.toList();
                                        }
                                      } else {
                                        selecteds.add(duration);
                                      }
                                      setState(() {
                                        selectedDurations[dayIndex] = selecteds;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: selectedDurations[dayIndex]
                                                  .contains(duration)
                                              ? AppColors.primary
                                              : (selectedDurations[dayIndex]
                                                              .length ==
                                                          2 &&
                                                      DateUtil.isInBetween(
                                                          duration: duration,
                                                          start:
                                                              selectedDurations[dayIndex]
                                                                  [0],
                                                          end: selectedDurations[
                                                              dayIndex][1]))
                                                  ? AppColors.primary
                                                      .withOpacity(0.4)
                                                  : index % 2 == 1
                                                      ? Colors.transparent
                                                      : AppColors.dark500,
                                          borderRadius: BorderRadius.circular(
                                              selectedDurations[dayIndex]
                                                      .contains(duration)
                                                  ? 5
                                                  : 0)),
                                      child: Center(
                                        child: Text(
                                          DateUtil.getDurationText(duration),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  color: selectedDurations[
                                                              dayIndex]
                                                          .contains(duration)
                                                      ? AppColors.white
                                                      : selectedDays
                                                              .contains(day)
                                                          ? Colors.white54
                                                          : Colors.white10),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
            ...selectedDurations.map((durations) {
              if (durations.length == 2) {
                return TemplateDurationSelectedItem(
                    durations: durations,
                    day: days[selectedDurations.indexOf(durations)],
                    onDelete: () {
                      int dayIndex = selectedDurations.indexOf(durations);
                      setState(() {
                        selectedDurations[dayIndex] = [];
                        selectedDays.remove(days[dayIndex]);
                      });
                    });
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }
}

class TemplateDurationSelectedItem extends StatelessWidget {
  const TemplateDurationSelectedItem(
      {Key? key,
      required this.durations,
      required this.day,
      required this.onDelete})
      : super(key: key);

  final List<Duration> durations;
  final String day;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onDelete,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.delete,
              color: AppColors.dark300,
            ),
          ),
        ),
        Text(
          "Every ${day} ${DateUtil.getDurationText(durations[0])} - ${DateUtil.getDurationText(durations[1])}",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.dark300),
        ),
      ],
    );
  }
}

class DateSelectorController {
  List<List<Duration>> selectedDurations = [];
}
