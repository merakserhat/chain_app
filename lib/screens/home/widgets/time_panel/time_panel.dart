import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/daily_model.dart';
import 'package:chain_app/screens/home/widgets/day_time_panel/day_time_panel.dart';
import 'package:chain_app/screens/home/widgets/time_panel/currently_dragging_routine.dart';
import 'package:chain_app/screens/home/widgets/time_panel/draggable_routine_circle.dart';
import 'package:chain_app/screens/home/widgets/time_panel/time_routine_list.dart';
import 'package:chain_app/screens/home/widgets/time_panel/timer_texts.dart';
import 'package:chain_app/utils/program.dart';
import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:chain_app/widgets/drag/drag_panel.dart';
import 'package:chain_app/widgets/drag/drag_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePanel extends StatefulWidget {
  static const double panelFixedTabHeight = 72;

  const TimePanel({Key? key, required this.panelDate}) : super(key: key);

  final DateTime panelDate;

  @override
  State<TimePanel> createState() => _TimePanelState();
}

class _TimePanelState extends State<TimePanel> {
  bool expanded = false;
  GlobalKey<DragPanelState> dragPanelKey = GlobalKey();
  bool initialized = false;
  bool sleepWakeChanged = false;

  @override
  void initState() {
    super.initState();
  }

  DragStateModel get dragState =>
      Provider.of<DragStateModel>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          dragState.updatePanelHeight();
          if (!initialized) {
            dragState.initializePuzzlePieces();
            dragState.templateStatusChanged(true, initialization: true);
            initialized = true;
          }

          dragState.updateStackHeightDiff(context);
        },
      );

      return Consumer<DragStateModel>(builder: (context, dragState, child) {
        return Container(
          key: dragState.panelKey,
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
                    height: TimePanel.panelFixedTabHeight - 28,
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
                              width: dragState.hourHeight,
                              child: Image.asset(
                                "assets/images/gm.png",
                                color: AppColors.dark500,
                              ),
                            ),
                          ),
                        ),
                        const TimeRoutineList(),
                        GestureDetector(
                          onTap: () => dragState.templateStatusChanged(
                              !dragState.isTemplatesActive),
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: dragState.isTemplatesActive
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
                        dragState.hourHeight != 0
                            ? TimerTexts(
                                wakeTime: dragState.dailyModel.wakeTime,
                                sleepTime: dragState.dailyModel.sleepTime,
                                panelHeight: dragState.panelHeight,
                                hourHeight: dragState.hourHeight,
                              )
                            : Container(),
                        DragPanel(
                          key: dragPanelKey,
                          hourHeight: dragState.hourHeight,
                          panelHeight: dragState.panelHeight,
                          wakeTime: dragState.dailyModel.wakeTime,
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
                          width: dragState.hourHeight,
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
              const CurrentlyDraggingRoutine(),
            ],
          ),
        );
      });
    });
  }

  void openDayTimeSettingsPanel() {
    showDialog(
      context: context,
      builder: (context) {
        return DayTimePanel(
          sleepTime: dragState.dailyModel.sleepTime,
          wakeTime: dragState.dailyModel.wakeTime,
          onUpdate: dragState.updateDayTime,
        );
      },
    );
  }
}
