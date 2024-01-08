import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/reminder_model.dart';
import 'package:chain_app/screens/home/widgets/activity/line_animated_text.dart';
import 'package:flutter/material.dart';

class TaskReminderItem extends StatelessWidget {
  TaskReminderItem({
    super.key,
    required this.color,
    required this.reminderModel,
    required this.isActive,
    required this.onStateChanged,
  });

  final Color color;
  final ReminderModel reminderModel;
  final bool isActive;
  final Function(bool) onStateChanged;
  final GlobalKey textKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColors.dark600),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.notifications_active : Icons.notifications_off,
            color: color,
          ),
          const SizedBox(width: 12),
          LineAnimatedText(
            text: reminderModel.text,
            isDone: !isActive,
            textKey: textKey,
            textStyle: Theme.of(context).textTheme.titleMedium!,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => onStateChanged(!isActive),
            child: Icon(
              isActive ? Icons.close : Icons.add,
              color: isActive ? AppColors.dark300 : color,
            ),
          ),
        ],
      ),
    );
  }
}
