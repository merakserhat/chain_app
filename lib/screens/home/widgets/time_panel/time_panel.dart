import 'dart:math';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/home/widgets/time_panel/draggable_routine_circle.dart';
import 'package:chain_app/screens/home/widgets/time_panel/timer_texts.dart';
import 'package:chain_app/widgets/drag/drag_item_shape.dart';
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
  static const double panelFixedTabHeight = 72;
  double stackHeightDiff = 0;
  DraggableRoutineInfo? draggingRoutine;

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
          if (currentHeight != 0) {
            currentHeight -= panelFixedTabHeight;
          }
          if (currentHeight != panelHeight) {
            setState(() {
              panelHeight = currentHeight;
              _dragModels.forEach((element) {
                element.fixDragModel(
                    panelHeight, (panelHeight / timerCount) * 2, wakeTime);
              });
            });
          }

          double newStackHeightDiff = stackHeightDiff =
              MediaQuery.of(context).size.height -
                  (panelKey.currentContext?.size?.height ?? 0);
          if (stackHeightDiff != newStackHeightDiff) {
            setState(() {
              stackHeightDiff = newStackHeightDiff;
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
            Column(
              children: [
                SizedBox(
                  height: panelFixedTabHeight - 28,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: SizedBox(
                          width: (panelHeight / timerCount) * 2,
                          child: Image.asset(
                            "assets/images/gm.png",
                            color: AppColors.dark500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                12,
                                (index) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: DraggableRoutineCircle(
                                        hourHeight:
                                            (panelHeight / timerCount) * 2,
                                        routine: RoutineModel.getBaseRoutine(),
                                        dragged: (draggableInfo) {
                                          if (draggableInfo.dragging) {
                                            setState(() {
                                              draggingRoutine = draggableInfo;
                                            });
                                          } else {
                                            createNewDraggableFromRoutines();
                                          }
                                        },
                                      ),
                                    )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                Expanded(
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
                ),
                SizedBox(
                  height: 28,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: (panelHeight / timerCount) * 2,
                        child: Image.asset(
                          "assets/images/gn.png",
                          color: AppColors.dark500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            draggingRoutine != null && draggingRoutine!.dragging
                ? Positioned(
                    top: draggingRoutine!.globalPos.dy - stackHeightDiff,
                    left: draggingRoutine!.globalPos.dx,
                    child: DragItemShape(
                      isPartial:
                          draggingRoutine!.routineModel.duration.inMinutes < 60,
                      height:
                          (draggingRoutine!.routineModel.duration.inMinutes /
                                  60) *
                              draggingRoutine!.hourHeight,
                      color: draggingRoutine!.routineModel.color,
                      dragItemWidth: draggingRoutine!.hourHeight,
                    ),
                  )
                : Container(),
          ],
        ),
      );
    });
  }

  void createNewDraggableFromRoutines() {
    setState(() {
      RoutineModel routine = draggingRoutine!.routineModel;
      DragModel<int> dragModel = DragModel(
          height: (draggingRoutine!.routineModel.duration.inMinutes / 60) *
              draggingRoutine!.hourHeight,
          y: draggingRoutine!.globalPos.dy -
              stackHeightDiff -
              panelFixedTabHeight +
              draggingRoutine!.hourHeight / 2,
          item: _dragModels.length,
          activityModel: ActivityModel(
              id: routine.id,
              time: const Duration(hours: 0),
              duration: routine.duration,
              title: routine.title,
              iconPath: routine.iconPath,
              color: routine.color));
      dragModel.fixActivityModel(
          panelHeight, draggingRoutine!.hourHeight, wakeTime);
      dragModel.fixDragModel(
          panelHeight, draggingRoutine!.hourHeight, wakeTime);
      _dragModels.add(dragModel);
      draggingRoutine = null;
    });
  }
}
