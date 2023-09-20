import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/habit/chain_path.dart';
import 'package:chain_app/screens/chain/routine/routine_settings_panel.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class HabitListItem extends StatelessWidget {
  const HabitListItem({
    Key? key,
    required this.routineModel,
    required this.isSelected,
    required this.onChange,
    this.enableEdit = false,
    this.onDelete,
  }) : super(key: key);

  final RoutineModel routineModel;
  final bool isSelected;
  final bool enableEdit;
  final Function(bool) onChange;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enableEdit) {
          showModalBottomSheet(
            context: context,
            // isScrollControlled: true,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            elevation: 0,
            builder: (context) => RoutineSettingsPanel(
              routineModel: routineModel,
              onDelete: onDelete ?? () {},
            ),
          );
          return;
        }
        onChange(!isSelected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.white : AppColors.dark600,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Image.asset(
                      routineModel.iconPath,
                      color: routineModel.color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routineModel.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: isSelected
                                    ? AppColors.dark700
                                    : Colors.white),
                      ),
                      Text(
                        DateUtil.getDurationText(
                          routineModel.duration,
                          minimize: true,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: isSelected
                                    ? AppColors.dark700
                                    : AppColors.dark400),
                      ),
                    ],
                  )),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        child: Image.asset(
                          "assets/images/fire.png",
                          color: AppColors.dark400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "12",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.dark400),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),
              ChainPath(),
            ],
          ),
        ),
      ),
    );
  }
}
