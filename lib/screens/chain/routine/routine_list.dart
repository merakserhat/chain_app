import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/chain/routine/routine_onboarding.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class RoutineList extends StatefulWidget {
  const RoutineList({Key? key}) : super(key: key);

  @override
  State<RoutineList> createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  List<RoutineModel> routines = [];

  @override
  Widget build(BuildContext context) {
    return routines.isEmpty
        ? _getEmptyRoutine()
        : SingleChildScrollView(
            child: Column(
                children: List.generate(
                    ((routines.length + 1) / 2).toInt(),
                    (i) => Row(
                          children: List.generate(2, (j) {
                            int routineIndex = 2 * i + j;
                            if (routineIndex == routines.length) {
                              return Expanded(child: Container());
                            }

                            return Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RoutineListItem(
                                  routineModel: routines[routineIndex],
                                  isSelected: false,
                                  onChange: (_) {}),
                            ));
                          }),
                        ))),
          );
  }

  Widget _getEmptyRoutine() {
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
                        selectRoutines: (routines) {
                          setState(() {
                            this.routines = routines;
                          });
                        },
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
