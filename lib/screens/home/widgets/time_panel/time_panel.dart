import 'dart:math';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/screens/home/widgets/time_panel/timer_texts.dart';
import 'package:chain_app/widgets/drag/drag_model.dart';
import 'package:chain_app/widgets/drag/drag_panel.dart';
import 'package:flutter/material.dart';

class TimePanel extends StatefulWidget {
  const TimePanel({Key? key}) : super(key: key);

  @override
  State<TimePanel> createState() => _TimePanelState();
}

class _TimePanelState extends State<TimePanel> {
  late Duration wakeTime;
  late Duration sleepTime;
  bool expanded = false;
  final GlobalKey panelKey = GlobalKey();
  double panelHeight = 0;

  List<DragModel<int>> _dragModels = [];
  @override
  void initState() {
    super.initState();
    wakeTime = Duration(hours: 8, minutes: 0);
    sleepTime = Duration(hours: 24, minutes: 0);
    _initializePuzzlePieces();
  }

  void _initializePuzzlePieces() {
    for (int i = 0; i < 4; i++) {
      double height = Random().nextDouble() * 80 + 40;
      Color color = Color.fromRGBO(
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
        1.0,
      );

      _dragModels.add(
        DragModel(
          height: height,
          item: i,
          y: i * 120,
          activityModel: ActivityModel.getBaseActivity(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double timerCount = (sleepTime.inMinutes - wakeTime.inMinutes) ~/ 30 + 1;

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          double currentHeight = panelKey.currentContext?.size?.height ?? 0;
          if (currentHeight != panelHeight) {
            setState(() {
              panelHeight = currentHeight;
              _dragModels.forEach((element) {
                element.fixDragModel(
                    panelHeight, (panelHeight / timerCount) * 2, wakeTime);
              });
            });
          }
        },
      );
      return Container(
        key: panelKey,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.dark600,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            TimerTexts(
              wakeTime: wakeTime,
              sleepTime: sleepTime,
              panelHeight: panelHeight,
            ),
            DragPanel(
              hourHeight: (panelHeight / timerCount) * 2,
              dragModels: _dragModels,
              panelHeight: panelHeight,
              wakeTime: wakeTime,
            ),
          ],
        ),
      );
    });
  }
}
