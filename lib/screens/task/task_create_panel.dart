import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:chain_app/screens/task/widgets/task_name_input_field.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class TaskCreatePanel extends StatefulWidget {
  const TaskCreatePanel({Key? key}) : super(key: key);

  @override
  State<TaskCreatePanel> createState() => _TaskCreatePanelState();
}

class _TaskCreatePanelState extends State<TaskCreatePanel> {
  late TaskIconData selectedTaskIcon;
  late TextEditingController taskNameController;

  @override
  void initState() {
    super.initState();
    selectedTaskIcon = TaskIconData.getFavTaskIcons(1).first;
    taskNameController = TextEditingController(text: selectedTaskIcon.name);
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
                    ),
                    const SizedBox(height: 24),
                    _getIconList(context),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Create Task",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.primary,
                    customPadding: EdgeInsets.symmetric(vertical: 12),
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
            "Task",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColors.primary),
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
          ),
        ),
      ],
    );
  }
}
