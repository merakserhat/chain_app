import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/task/widgets/task_icon_picker.dart';
import 'package:chain_app/utils/id_util.dart';
import 'package:chain_app/widgets/custom_checkbox.dart';
import 'package:chain_app/screens/task/widgets/task_color_picker.dart';
import 'package:chain_app/screens/task/widgets/task_duration_picker.dart';
import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:chain_app/screens/task/widgets/task_name_input_field.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateRoutinePanel extends StatefulWidget {
  const CreateRoutinePanel({
    Key? key,
    required this.initialDuration,
    required this.onCreate,
  }) : super(key: key);

  final Duration initialDuration;
  final Function(RoutineModel routineModel) onCreate;

  @override
  State<CreateRoutinePanel> createState() => _TaskCreatePanelState();
}

class _TaskCreatePanelState extends State<CreateRoutinePanel> {
  late TaskIconData selectedTaskIcon;
  late TextEditingController taskNameController;
  late Color selectedColor;
  late Duration selectedDuration;
  late bool isShow = true;

  @override
  void initState() {
    super.initState();
    selectedTaskIcon = TaskIconData.getFavTaskIcons(1).first;
    taskNameController = TextEditingController(text: selectedTaskIcon.name);
    selectedColor = AppColors.primary;
    selectedDuration = widget.initialDuration;
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
                    TaskIconPicker(
                        color: selectedColor,
                        selectedTaskIcon: selectedTaskIcon,
                        onChange: (taskIconData) {
                          setState(() {
                            selectedTaskIcon = taskIconData;
                            taskNameController.text = selectedTaskIcon.name;
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
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Create Routine",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: selectedColor,
                    customPadding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      int id = IdUtil.generateIntId();
                      RoutineModel routineModel = RoutineModel(
                        id: id,
                        showOnPanel: isShow,
                        duration: selectedDuration,
                        title: taskNameController.text,
                        iconPath: selectedTaskIcon.src,
                        color: selectedColor,
                        reminders: [],
                      );
                      widget.onCreate(routineModel);
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
