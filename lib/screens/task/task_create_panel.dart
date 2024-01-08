import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/screens/task/widgets/task_color_picker.dart';
import 'package:chain_app/screens/task/widgets/task_duration_picker.dart';
import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:chain_app/screens/task/widgets/task_name_input_field.dart';
import 'package:chain_app/screens/task/widgets/task_reminder_picker.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskCreatePanel extends StatefulWidget {
  const TaskCreatePanel({
    Key? key,
    required this.initialDuration,
    required this.initialTime,
    this.onCreate,
    this.onEdit,
    this.editedActivity,
  }) : super(key: key);

  final Duration initialDuration;
  final Duration initialTime;
  final ActivityModel? editedActivity;
  final Function(ActivityModel activityModel)? onCreate;
  final Function(ActivityModel activityModel)? onEdit;

  @override
  State<TaskCreatePanel> createState() => _TaskCreatePanelState();
}

class _TaskCreatePanelState extends State<TaskCreatePanel> {
  late TaskIconData selectedTaskIcon;
  late TextEditingController taskNameController;
  late Color selectedColor;
  late Duration selectedDuration;
  late List<ReminderModel> selectedReminders;

  @override
  void initState() {
    super.initState();
    selectedTaskIcon =
        TaskIconData.getTaskIconWithPath(widget.editedActivity?.iconPath) ??
            TaskIconData.getFavTaskIcons(1).first;
    taskNameController = TextEditingController(
        text: widget.editedActivity?.title ?? selectedTaskIcon.name);
    selectedColor = widget.editedActivity?.color ?? AppColors.primary;
    selectedDuration = widget.initialDuration;
    selectedReminders = widget.editedActivity?.reminders ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: AppColors.dark700,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getPanelHeader(context),
                    const SizedBox(height: 8),
                    TaskNameInput(
                      taskIconData: selectedTaskIcon,
                      taskNameController: taskNameController,
                      selectedColor: selectedColor,
                    ),
                    const SizedBox(height: 24),
                    _getIconList(context),
                    const SizedBox(height: 32),
                    TaskColorPicker(
                      selectedColor: selectedColor,
                      onSelected: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    TaskDurationPicker(
                      selectedColor: selectedColor,
                      selectedDuration: selectedDuration,
                      onSelected: (duration) {
                        setState(() {
                          selectedDuration = duration;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    TaskReminderPicker(
                      selectedColor: selectedColor,
                      selectedReminders: selectedReminders,
                      onReminderStateChanged: (reminderModel, isSelected) {
                        if (isSelected &&
                            !selectedReminders.contains(reminderModel)) {
                          setState(() {
                            selectedReminders.add(reminderModel);
                          });
                          return;
                        }

                        if (!isSelected &&
                            selectedReminders.contains(reminderModel)) {
                          setState(() {
                            selectedReminders.remove(reminderModel);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: widget.onEdit == null
                        ? "Create Activity"
                        : "Edit Activity",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: selectedColor,
                    customPadding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      String id =
                          widget.editedActivity?.id ?? const Uuid().v1();
                      ActivityModel activityModel = ActivityModel(
                        id: id,
                        time: widget.initialTime,
                        duration: selectedDuration,
                        title: taskNameController.text,
                        iconPath: selectedTaskIcon.src,
                        color: selectedColor,
                        reminders: selectedReminders,
                      );
                      widget.onCreate != null
                          ? widget.onCreate!(activityModel)
                          : widget.onEdit!(activityModel);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPanelHeader(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: AppColors.dark600,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            widget.editedActivity == null ? "Create " : "Edit ",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Activity",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: selectedColor),
          ),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.close_outlined,
                color: AppColors.dark300,
                size: 36,
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _getIconList(BuildContext context) {
    int favIconCount =
        MediaQuery.of(context).size.width ~/ (TaskIcon.size + 8) - 1;
    List<TaskIconData> favIcons = TaskIconData.getFavTaskIcons(favIconCount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TaskIcon(
          iconData: TaskIconData.coffee,
          othersButton: true,
          onSelected: (_) {},
          selectedColor: selectedColor,
        ),
        ...favIcons.map(
          (taskIcon) => TaskIcon(
            iconData: taskIcon,
            selected: taskIcon == selectedTaskIcon,
            onSelected: (taskIconData) {
              setState(() {
                selectedTaskIcon = taskIconData;
                taskNameController.text = selectedTaskIcon.name;
              });
            },
            selectedColor: selectedColor,
          ),
        ),
      ],
    );
  }
}
