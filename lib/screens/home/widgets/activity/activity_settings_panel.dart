import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/delete_warning.dart';
import 'package:chain_app/widgets/square_icon_button.dart';
import 'package:flutter/material.dart';

class ActivitySettingsPanel extends StatefulWidget {
  const ActivitySettingsPanel(
      {Key? key,
      required this.activityModel,
      required this.onDelete,
      required this.onStatusChanged})
      : super(key: key);

  final ActivityModel activityModel;
  final VoidCallback onDelete;
  final Function(bool) onStatusChanged;

  @override
  State<ActivitySettingsPanel> createState() => _ActivitySettingsPanelState();
}

class _ActivitySettingsPanelState extends State<ActivitySettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          width: double.infinity,
          height: 240,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.dark500, width: 1),
            color: AppColors.dark900,
          ),
          child: Column(
            children: [
              _getPanelHeader(context),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SquareIconButton(
                        icon: Icons.delete,
                        label: "Delete",
                        color: widget.activityModel.color,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            // isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            builder: (context) => DeleteWarning(
                                objectName: "activity",
                                onDelete: () {
                                  Navigator.of(context).pop();
                                  widget.onDelete();
                                }),
                          );
                        }),
                    const SizedBox(width: 8),
                    SquareIconButton(
                        icon: Icons.edit,
                        label: "Edit",
                        color: widget.activityModel.color,
                        onTap: () {
                          //TODO: edit
                        }),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SquareIconButton(
                        icon: Icons.check_circle_outline,
                        label: widget.activityModel.isDone
                            ? "Incomplete"
                            : "Complete",
                        color: widget.activityModel.color,
                        onTap: () {
                          widget.onStatusChanged(!widget.activityModel.isDone);
                          setState(() {});
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          )),
    );
  }

  Widget _getPanelHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 32,
              child: Image.asset(
                widget.activityModel.iconPath,
                color: widget.activityModel.color,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.activityModel.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  DateUtil.getDurationText(
                    widget.activityModel.duration,
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
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 24,
                  child: Image.asset(
                    "assets/images/cross.png",
                    color: AppColors.dark300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.dark500,
        )
      ],
    );
  }
}
