import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class TimePanel extends StatefulWidget {
  const TimePanel({Key? key}) : super(key: key);

  @override
  State<TimePanel> createState() => _TimePanelState();
}

class _TimePanelState extends State<TimePanel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.dark600,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Text(
          "sa",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
