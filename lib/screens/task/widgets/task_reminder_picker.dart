import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/screens/task/widgets/task_create_base_item.dart';
import 'package:chain_app/screens/task/widgets/task_reminder_item.dart';
import 'package:flutter/material.dart';

class TaskReminderPicker extends StatelessWidget {
  TaskReminderPicker({
    super.key,
    required this.selectedColor,
    required this.selectedReminders,
    required this.onReminderStateChanged,
  });

  final Color selectedColor;
  final List<ReminderModel> selectedReminders;
  final Function(ReminderModel, bool) onReminderStateChanged;

  final List<ReminderModel> customReminders = [
    ReminderModel(text: "At start of task"),
    ReminderModel(
        timeDelayInMinutes: -5,
        isAfterActivity: false,
        text: "5m before activity"),
    ReminderModel(
        timeDelayInMinutes: -30,
        isAfterActivity: false,
        text: "30m before activity"),
    ReminderModel(isAfterActivity: true, text: "At end of task"),
  ];

  @override
  Widget build(BuildContext context) {
    return TaskCreateBaseItem(
      label: "Need alerts?",
      child: Column(
        children: customReminders
            .map((e) => TaskReminderItem(
                  color: selectedColor,
                  reminderModel: e,
                  isActive: selectedReminders.contains(e),
                  onStateChanged: (isActive) =>
                      onReminderStateChanged(e, isActive),
                ))
            .toList(),
      ),
    );
  }
}
