import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/chain/routine/routine_onboarding.dart';
import 'package:chain_app/utils/program.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class RoutineList extends StatelessWidget {
  const RoutineList({
    Key? key,
    required this.selectOnboardingRoutines,
    required this.deleteRoutine,
  }) : super(key: key);
  final Function(List<RoutineModel>) selectOnboardingRoutines;
  final Function(RoutineModel) deleteRoutine;

  @override
  Widget build(BuildContext context) {
    return Program().routines.isEmpty
        ? _getEmptyRoutine(context)
        : SingleChildScrollView(
            child: Column(
                children: List.generate(
                    ((Program().routines.length + 1) / 2).toInt(),
                    (i) => Row(
                          children: List.generate(2, (j) {
                            int routineIndex = 2 * i + j;
                            if (routineIndex == Program().routines.length) {
                              return Expanded(child: Container());
                            }

                            return Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RoutineListItem(
                                routineModel: Program().routines[routineIndex],
                                isSelected: false,
                                enableEdit: true,
                                onDelete: () {
                                  deleteRoutine(
                                      Program().routines[routineIndex]);
                                },
                                onChange: (_) {},
                              ),
                            ));
                          }),
                        ))),
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
