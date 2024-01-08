import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class RoutineOnboarding extends StatefulWidget {
  const RoutineOnboarding({Key? key, required this.selectRoutines})
      : super(key: key);

  final Function(List<RoutineModel>) selectRoutines;

  @override
  State<RoutineOnboarding> createState() => _RoutineOnboardingState();
}

class _RoutineOnboardingState extends State<RoutineOnboarding> {
  List<int> selectedIndexes = [];
  List<RoutineModel> routines = [
    RoutineModel(
        id: "0",
        duration: const Duration(hours: 1),
        title: "Meal",
        iconPath: "assets/images/icons/food.png",
        showOnPanel: true,
        color: AppColors.yellow,
        reminders: []),
    RoutineModel(
        id: "1",
        duration: const Duration(minutes: 90),
        title: "Gym",
        iconPath: "assets/images/icons/dumbell.png",
        showOnPanel: true,
        color: AppColors.red,
        reminders: []),
    RoutineModel(
        id: "2",
        duration: const Duration(hours: 2),
        title: "Study",
        iconPath: "assets/images/icons/pen.png",
        showOnPanel: true,
        color: AppColors.blue,
        reminders: []),
    RoutineModel(
        id: "3",
        duration: const Duration(hours: 1),
        title: "Cooking",
        iconPath: "assets/images/icons/cooking.png",
        showOnPanel: true,
        color: AppColors.purple,
        reminders: []),
    RoutineModel(
        id: "4",
        duration: const Duration(hours: 2),
        title: "Football",
        iconPath: "assets/images/icons/football.png",
        showOnPanel: true,
        color: AppColors.green,
        reminders: []),
    RoutineModel(
        id: "5",
        duration: const Duration(hours: 2),
        title: "Film",
        iconPath: "assets/images/icons/monitor.png",
        showOnPanel: true,
        color: AppColors.darkBlue,
        reminders: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 48),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.dark700),
            child: Column(
              children: [
                Text(
                  "Which are the following activities you regularly do?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.3,
                  children: List.generate(
                      routines.length,
                      (index) => Row(
                            children: [
                              Expanded(
                                child: RoutineListItem(
                                    routineModel: routines[index],
                                    isSelected: selectedIndexes.contains(index),
                                    onChange: (selected) {
                                      if (selected) {
                                        selectedIndexes.add(index);
                                      } else {
                                        selectedIndexes.remove(index);
                                      }
                                      setState(() {});
                                    }),
                              ),
                            ],
                          )),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: "Complete",
                  onPressed: () {
                    List<RoutineModel> selectedRoutines =
                        selectedIndexes.map((i) => routines[i]).toList();
                    widget.selectRoutines(selectedRoutines);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
