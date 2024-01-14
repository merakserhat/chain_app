import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/delete_warning.dart';
import 'package:chain_app/widgets/square_icon_button.dart';
import 'package:flutter/material.dart';

class RoutineSettingsPanel extends StatelessWidget {
  const RoutineSettingsPanel({
    Key? key,
    required this.routineModel,
    required this.onDelete,
    this.objectName = "routine",
    required this.onEdit,
  }) : super(key: key);

  final RoutineModel routineModel;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final String objectName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.dark500, width: 1),
            color: AppColors.dark900,
          ),
          child: Column(
            children: [
              _getPanelHeader(context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SquareIconButton(
                        icon: Icons.delete,
                        label: "Delete",
                        color: routineModel.color,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            // isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            builder: (context) => DeleteWarning(
                                objectName: objectName,
                                onDelete: () {
                                  Navigator.of(context).pop();
                                  onDelete();
                                }),
                          );
                        }),
                    const SizedBox(width: 8),
                    SquareIconButton(
                      icon: Icons.edit,
                      label: "Edit",
                      color: routineModel.color,
                      onTap: onEdit,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _getPanelHeader(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              SizedBox(
                width: 32,
                child: Image.asset(
                  routineModel.iconPath,
                  color: routineModel.color,
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    routineModel.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    DateUtil.getDurationText(
                      routineModel.duration,
                      minimize: true,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: AppColors.dark400),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 24,
                    child: Image.asset(
                      "assets/images/cross.png",
                      color: AppColors.dark300,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.dark500,
          )
        ],
      ),
    );
  }
}
