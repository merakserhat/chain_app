import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_settings_panel.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class RoutineListItem extends StatelessWidget {
  const RoutineListItem({
    Key? key,
    required this.routineModel,
    required this.isSelected,
    required this.onChange,
    this.enableEdit = false,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  final RoutineModel routineModel;
  final bool isSelected;
  final bool enableEdit;
  final Function(bool) onChange;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

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
              onEdit: onEdit ?? () {},
            ),
          );
          return;
        }
        onChange(!isSelected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.white : AppColors.dark600,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
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
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: isSelected ? AppColors.dark700 : Colors.white),
                  ),
                  Text(
                    DateUtil.getDurationText(
                      routineModel.duration,
                      minimize: true,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color:
                            isSelected ? AppColors.dark700 : AppColors.dark400),
                  ),
                ],
              )),
              routineModel.showOnPanel
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.remove_red_eye,
                        size: 16,
                        color: AppColors.dark400,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
