import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/habit/chain_path.dart';
import 'package:chain_app/screens/chain/habit/habit_list_item.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/chain/routine/routine_onboarding.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class HabitList extends StatelessWidget {
  const HabitList({
    Key? key,
    required this.routines,
    required this.selectOnboardingRoutines,
    required this.deleteRoutine,
  }) : super(key: key);
  final List<RoutineModel> routines;
  final Function(List<RoutineModel>) selectOnboardingRoutines;
  final Function(RoutineModel) deleteRoutine;

  @override
  Widget build(BuildContext context) {
    return routines.isEmpty
        ? _getEmptyRoutine(context)
        : SingleChildScrollView(
            child: Column(children: [
              HabitListItem(
                routineModel: routines[0],
                isSelected: false,
                onChange: (_) {},
              ),
            ]),
          );
  }

  Widget _getEmptyRoutine(BuildContext context) {
    // return Container();
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Routines are the basic activities you do throughout the day.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.dark300),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: "Set Routines",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RoutineOnboarding(
                          selectRoutines: selectOnboardingRoutines);
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
