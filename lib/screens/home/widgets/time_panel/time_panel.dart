import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/daily_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:chain_app/screens/home/widgets/day_time_panel/day_time_panel.dart';
import 'package:chain_app/screens/home/widgets/time_panel/draggable_routine_circle.dart';
import 'package:chain_app/screens/home/widgets/time_panel/timer_texts.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:chain_app/utils/program.dart';
import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:chain_app/widgets/drag/drag_model.dart';
import 'package:chain_app/widgets/drag/drag_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePanel extends StatefulWidget {
  const TimePanel({Key? key, required this.panelDate}) : super(key: key);

  final DateTime panelDate;

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
  GlobalKey<DragPanelState> dragPanelKey = GlobalKey();

  bool initialized = false;
  bool sleepWakeChanged = false;
  bool templatesActive = true;

  final List<DragModel<int>> _dragModels = [];

  @override
  void initState() {
    super.initState();
    wakeTime = const Duration(hours: 8, minutes: 0);
    sleepTime = const Duration(hours: 24, minutes: 0);
  }

  void actionCompleted() {
    LocalService().saveDay(
      DailyModel(
        activities: _dragModels.map((e) => e.activityModel).toList(),
        wakeTime: wakeTime,
        sleepTime: sleepTime,
        date: widget.panelDate,
      ),
    );
  }

  double get timerCount => (sleepTime.inMinutes - wakeTime.inMinutes) ~/ 30 + 1;

  double get hourHeight => (panelHeight / timerCount) * 2;

  void _initializePuzzlePieces() {
    DailyModel? dailyModel = LocalService().loadDaily(widget.panelDate);
    if (dailyModel != null) {
      wakeTime = dailyModel.wakeTime;
      sleepTime = dailyModel.sleepTime;
      for (ActivityModel activityModel in dailyModel.activities) {
        DragModel<int> dragModel = DragModel(
          height: 0,
          item: 0,
          y: 0,
          activityModel: activityModel,
          isMoving: false,
        );
        dragModel.fixDragModel(panelHeight, hourHeight, wakeTime);
        _dragModels.add(dragModel);
      }

      setState(() {
        sleepWakeChanged = true;
      });
    }

    setState(() {
      initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          double currentHeight = panelKey.currentContext?.size?.height ?? 0;
          if (currentHeight != 0) {
            currentHeight -= panelFixedTabHeight;
          }
          if (currentHeight != panelHeight || sleepWakeChanged) {
            setState(() {
              panelHeight = currentHeight;
              _dragModels.forEach((element) {
                element.fixDragModel(panelHeight, hourHeight, wakeTime);
              });
              sleepWakeChanged = false;
            });

            if (!initialized) {
              _initializePuzzlePieces();
              templateStatusChanged(templatesActive, initialization: true);
            }
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
                        padding: const EdgeInsets.only(left: 50),
                        child: GestureDetector(
                          onTap: () {
                            openDayTimeSettingsPanel();
                          },
                          child: SizedBox(
                            width: hourHeight,
                            child: Image.asset(
                              "assets/images/gm.png",
                              color: AppColors.dark500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Consumer<Program>(
                              builder: (context, program, child) {
                            return Row(
                              children: List.generate(
                                  Program().routines.length,
                                  (index) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: DraggableRoutineCircle(
                                          hourHeight: hourHeight,
                                          routine: Program().routines[index],
                                          dragged: (draggableInfo) {
                                            if (draggableInfo.dragging) {
                                              setState(() {
                                                draggingRoutine = draggableInfo;
                                              });
                                              return;
                                            }
                                            if (draggingRoutine!.globalPos.dx <
                                                    90 &&
                                                10 <
                                                    draggingRoutine!
                                                        .globalPos.dx) {
                                              createNewDraggableFromRoutines();
                                            } else {
                                              setState(() {
                                                draggingRoutine = null;
                                              });
                                            }
                                          },
                                        ),
                                      )),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => templateStatusChanged(!templatesActive),
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: templatesActive
                              ? AppColors.dark400
                              : AppColors.dark500,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      hourHeight != 0
                          ? TimerTexts(
                              wakeTime: wakeTime,
                              sleepTime: sleepTime,
                              panelHeight: panelHeight,
                              hourHeight: hourHeight,
                            )
                          : Container(),
                      DragPanel(
                        key: dragPanelKey,
                        hourHeight: hourHeight,
                        dragModels: _dragModels,
                        panelHeight: panelHeight,
                        wakeTime: wakeTime,
                        actionCompleted: actionCompleted,
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
                        width: hourHeight,
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
                      iconPath: draggingRoutine!.routineModel.iconPath,
                      isPartial:
                          draggingRoutine!.routineModel.duration.inMinutes < 60,
                      height:
                          (draggingRoutine!.routineModel.duration.inMinutes /
                                  60) *
                              draggingRoutine!.hourHeight,
                      color: draggingRoutine!.routineModel.color,
                      dragItemWidth: draggingRoutine!.hourHeight,
                      isMoving: true,
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
          isMoving: false,
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
      dragPanelKey.currentState?.rearrangeOthers(dragModel);
      draggingRoutine = null;
    });

    actionCompleted();
  }

  void createNewDraggableFromTemplates(TemplateModel templateModel) {
    setState(() {
      RoutineModel routine = templateModel.toRoutine();
      if (templateModel.durations[widget.panelDate.weekday - 1].isEmpty) {
        return;
      }

      if (_dragModels
          .map((e) => e.activityModel)
          .toList()
          .any((activity) => activity.templateId == templateModel.id)) {
        return;
      }

      Duration duration = Duration(
          minutes: templateModel
                  .durations[widget.panelDate.weekday - 1][1].inMinutes -
              templateModel
                  .durations[widget.panelDate.weekday - 1][0].inMinutes);
      Duration time = Duration(
          minutes: templateModel
              .durations[widget.panelDate.weekday - 1][0].inMinutes);

      DragModel<int> dragModel = DragModel(
          height: 0,
          y: 0,
          item: _dragModels.length,
          isMoving: false,
          activityModel: ActivityModel(
            id: routine.id,
            time: time,
            duration: duration,
            title: routine.title,
            iconPath: routine.iconPath,
            color: routine.color,
            fromTemplate: true,
            templateId: templateModel.id,
          ));
      dragModel.fixDragModel(panelHeight, hourHeight, wakeTime);
      _dragModels.add(dragModel);
      // dragPanelKey.currentState?.rearrangeOthers(dragModel);
      draggingRoutine = null;
    });
  }

  templateStatusChanged(bool status, {bool initialization = false}) {
    if (!status) {
      _dragModels.removeWhere((element) => element.activityModel.fromTemplate);
    } else {
      for (var template in Program().templates) {
        createNewDraggableFromTemplates(template);
      }
    }

    if (!initialization) {
      setState(() {
        templatesActive = status;
      });
      actionCompleted();
    }
  }

  void openDayTimeSettingsPanel() {
    showDialog(
      context: context,
      builder: (context) {
        return DayTimePanel(
          sleepTime: sleepTime,
          wakeTime: wakeTime,
          onUpdate: (Duration sleepTime, Duration wakeTime) {
            setState(() {
              this.sleepTime = sleepTime;
              this.wakeTime = wakeTime;
            });

            for (DragModel dragModel in _dragModels) {
              dragModel.fixDragModel(panelHeight, hourHeight, wakeTime);
            }

            actionCompleted();
          },
        );
      },
    );
  }
}
