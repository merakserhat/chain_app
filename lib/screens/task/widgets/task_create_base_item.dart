import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class TaskCreateBaseItem extends StatelessWidget {
  const TaskCreateBaseItem({Key? key, required this.label, required this.child})
      : super(key: key);

  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: AppColors.dark400),
          ),
          const SizedBox(
            height: 8,
          ),
          child
        ],
      ),
    );
  }
}
