import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/task/widgets/task_icon_picker.dart';
import 'package:chain_app/screens/task/widgets/task_reminder_picker.dart';
import 'package:chain_app/utils/id_util.dart';
import 'package:chain_app/widgets/custom_checkbox.dart';
import 'package:chain_app/screens/task/widgets/task_color_picker.dart';
import 'package:chain_app/screens/task/widgets/task_duration_picker.dart';
import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:chain_app/screens/task/widgets/task_name_input_field.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class CreateRoutinePanel extends StatefulWidget {
  const CreateRoutinePanel({
    Key? key,
    required this.initialDuration,
    this.onCreate,
    this.editedRoutine,
    this.onEdit,
  }) : super(key: key);

  final Duration initialDuration;
  final Function(RoutineModel routineModel)? onCreate;
  final Function(RoutineModel routineModel)? onEdit;
  final RoutineModel? editedRoutine;

  @override
  State<CreateRoutinePanel> createState() => _TaskCreatePanelState();
}

class _TaskCreatePanelState extends State<CreateRoutinePanel> {
  late TaskIconData selectedTaskIcon;
  late TextEditingController taskNameController;
  late Color selectedColor;
  late Duration selectedDuration;
  late bool isShow = true;
  late List<ReminderModel> selectedReminders;

  @override
  void initState() {
    super.initState();
    selectedTaskIcon =
        TaskIconData.getTaskIconWithPath(widget.editedRoutine?.iconPath) ??
            TaskIconData.getFavTaskIcons(1).first;
    taskNameController = TextEditingController(
        text: widget.editedRoutine?.title ?? selectedTaskIcon.name);
    selectedColor = widget.editedRoutine?.color ?? AppColors.primary;
    selectedDuration = widget.editedRoutine?.duration ?? widget.initialDuration;
    selectedReminders = widget.editedRoutine?.reminders ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: AppColors.dark700,
        ),
        child: Column(
          children: [
            _getPanelHeader(context),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TaskNameInput(
                            taskIconData: selectedTaskIcon,
                            taskNameController: taskNameController,
                            selectedColor: selectedColor,
                          ),
                          const SizedBox(height: 24),
                          TaskIconPicker(
                              color: selectedColor,
                              selectedTaskIcon: selectedTaskIcon,
                              onChange: (taskIconData) {
                                setState(() {
                                  selectedTaskIcon = taskIconData;
                                  taskNameController.text =
                                      selectedTaskIcon.name;
                                });
                              }),
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
                          CustomCheckbox(
                            text: "Show on panel?",
                            change: (isShow) {
                              if (isShow == null) {
                                return;
                              }
                              setState(() {
                                this.isShow = isShow;
                              });
                            },
                            isChecked: isShow,
                            color: selectedColor,
                          ),
                          TaskReminderPicker(
                            selectedColor: selectedColor,
                            selectedReminders: selectedReminders,
                            onReminderStateChanged:
                                (reminderModel, isSelected) {
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
                          const SizedBox(height: 82),
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
                              ? "Create Routine"
                              : "Edit Routine",
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: selectedColor,
                          customPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          onPressed: () {
                            int id = IdUtil.generateIntId();
                            RoutineModel routineModel = RoutineModel(
                              id: id,
                              showOnPanel: isShow,
                              duration: selectedDuration,
                              title: taskNameController.text,
                              iconPath: selectedTaskIcon.src,
                              color: selectedColor,
                              reminders: selectedReminders,
                            );
                            widget.onCreate != null
                                ? widget.onCreate!(routineModel)
                                : widget.onEdit!(routineModel);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
            "Create ",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Routine",
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
}
