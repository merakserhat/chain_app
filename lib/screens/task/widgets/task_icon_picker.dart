import 'package:chain_app/screens/task/widgets/task_icon.dart';
import 'package:chain_app/widgets/custom_wrap.dart';
import 'package:flutter/material.dart';

class TaskIconPicker extends StatefulWidget {
  const TaskIconPicker({
    super.key,
    required this.color,
    required this.selectedTaskIcon,
    required this.onChange,
  });

  final Color color;
  final TaskIconData selectedTaskIcon;
  final Function(TaskIconData) onChange;

  @override
  State<TaskIconPicker> createState() => _TaskIconPickerState();
}

class _TaskIconPickerState extends State<TaskIconPicker> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      height: isOpen ? 60 : 130,
      child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: CustomWrap(
            widgets: [
              TaskIcon(
                iconData: !isOpen ? TaskIconData.less : TaskIconData.others,
                othersButton: true,
                onSelected: (_) {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                selectedColor: widget.color,
              ),
              ...TaskIconData.taskIcons.map(
                (taskIcon) => TaskIcon(
                  iconData: taskIcon,
                  selected: taskIcon == widget.selectedTaskIcon,
                  onSelected: widget.onChange,
                  selectedColor: widget.color,
                ),
              )
            ],
            cs: MediaQuery.of(context).size.width ~/ (TaskIcon.size + 8) - 1,
          )),
    );
  }
}
