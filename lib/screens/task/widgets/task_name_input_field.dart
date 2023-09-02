import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:flutter/material.dart';

class TaskNameInput extends StatefulWidget {
  const TaskNameInput(
      {Key? key, required this.taskIconData, required this.taskNameController})
      : super(key: key);
  final TaskIconData taskIconData;
  final TextEditingController taskNameController;

  @override
  State<TaskNameInput> createState() => _TaskNameInputState();
}

class _TaskNameInputState extends State<TaskNameInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: TaskIcon.size + 8,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          TaskIcon(
            iconData: widget.taskIconData,
            onSelected: (_) {},
            selected: false,
            panel: true,
          ),
          const SizedBox(width: 12),
          Expanded(
              child: TextField(
            controller: widget.taskNameController,
            decoration: InputDecoration(
              hintText: widget.taskIconData.name,
              hintStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.dark400),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            style: Theme.of(context).textTheme.titleLarge,
          )),
        ],
      ),
    );
  }
}
