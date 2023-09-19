import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:chain_app/screens/chain/routine/routine_settings_panel.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TemplateListItem extends StatelessWidget {
  const TemplateListItem({
    Key? key,
    required this.templateModel,
    required this.isSelected,
    required this.onChange,
    this.enableEdit = false,
    this.onDelete,
  }) : super(key: key);

  final TemplateModel templateModel;
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
              routineModel: templateModel,
              objectName: "template",
              onDelete: onDelete ?? () {},
            ),
          );
          return;
        }
        onChange(!isSelected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
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
                  templateModel.iconPath,
                  color: templateModel.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      templateModel.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: isSelected ? AppColors.dark700 : Colors.white),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: DateUtil.days
                              .map(
                                (e) => Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: templateModel
                                                    .durations[DateUtil.days
                                                        .indexOf(e)]
                                                    .length ==
                                                2
                                            ? templateModel.color
                                            : AppColors.dark500,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              e == DateUtil.days[0] ? 5 : 0),
                                          bottomLeft: Radius.circular(
                                              e == DateUtil.days[0] ? 5 : 0),
                                          topRight: Radius.circular(
                                              e == DateUtil.days[6] ? 5 : 0),
                                          bottomRight: Radius.circular(
                                              e == DateUtil.days[6] ? 5 : 0),
                                        )),
                                    child: Center(child: Text(e)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
