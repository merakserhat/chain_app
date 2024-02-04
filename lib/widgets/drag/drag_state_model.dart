import 'dart:math';

import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/daily_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:chain_app/screens/home/widgets/time_panel/draggable_routine_circle.dart';
import 'package:chain_app/screens/home/widgets/time_panel/time_panel.dart';
import 'package:chain_app/screens/task/task_create_panel.dart';
import 'package:chain_app/services/notification_service.dart';
import 'package:chain_app/utils/id_util.dart';
import 'package:chain_app/utils/program.dart';
import 'package:chain_app/widgets/drag/drag_item.dart';
import 'package:chain_app/widgets/drag/drag_model.dart';
import 'package:chain_app/widgets/drag/dragging_info.dart';
import 'package:flutter/material.dart';

import '../../services/local_service.dart';

class DragStateModel extends ChangeNotifier {
  final DailyModel dailyModel;
  final List<DragModel<int>> dragModels = [];
  final List<Offset> overlaps = [];
  double panelHeight = 0;
  double newDraggableStartPos = 0;
  double newDraggableEndPos = 0;
  double stackHeightDiff = 0;
  DraggableRoutineInfo? draggingRoutine;
  final GlobalKey panelKey = GlobalKey();
  bool isTemplatesActive = true;

  DragStateModel({required this.dailyModel}) {
    print("Created with " + dailyModel.date.toString());
  }

  double get timerCount =>
      (dailyModel.sleepTime.inMinutes - dailyModel.wakeTime.inMinutes) ~/ 30 +
      1;

  double get hourHeight => (panelHeight / timerCount) * 2;

  void updateStackHeightDiff(BuildContext context) {
    double newStackHeightDiff = Program().safeScreenSize -
        (panelKey.currentContext?.size?.height ?? 0) +
        Program().topPadding;

    if (stackHeightDiff != newStackHeightDiff) {
      stackHeightDiff = newStackHeightDiff;
      notifyListeners();
    }
  }

  void updatePanelHeight() {
    double currentHeight = panelKey.currentContext?.size?.height ?? 0;
    if (currentHeight != 0) {
      currentHeight -= TimePanel.panelFixedTabHeight;
    }
    if (currentHeight != panelHeight) {
      panelHeight = currentHeight;
      fixDragModels();
      notifyListeners();
    }
  }

  double roundToNearestMultipleOfHeight(double number) {
    double roundDifference = number % (hourHeight / 2);
    double rounded2 = number - roundDifference;
    if (roundDifference > hourHeight / 4) {
      rounded2 += hourHeight / 2;
    }
    return max(0, rounded2);
  }

  void onDrag(DraggingInfo draggingInfo) {
    draggingInfo.dragModel.y += draggingInfo.dy;
    draggingInfo.dragModel.isMoving = true;
    notifyListeners();

    if (!draggingInfo.continues) {
      draggingInfo.dragModel.isMoving = false;
      draggingInfo.dragModel.y =
          roundToNearestMultipleOfHeight(draggingInfo.dragModel.y).toDouble();
      if (draggingInfo.dragModel.y + draggingInfo.dragModel.height >
          panelHeight - hourHeight / 2) {
        draggingInfo.dragModel.y = roundToNearestMultipleOfHeight(
            panelHeight - draggingInfo.dragModel.height - hourHeight / 2);
      }
      draggingInfo.dragModel
          .fixActivityModel(panelHeight, hourHeight, dailyModel.wakeTime);
      rearrangeOthers(draggingInfo.dragModel);
      save();
      notifyListeners();
      return;
    }
  }

  void onResizeTop(DraggingInfo draggingInfo) {
    double currentPosition = draggingInfo.dragModel.y;
    double currentHeight = draggingInfo.dragModel.height;
    double maxHeight = DragItem.dragItemMaxHeight;
    double newPosition = currentPosition + draggingInfo.dy;
    double newHeight = currentHeight - draggingInfo.dy;
    draggingInfo.dragModel.isMoving = true;
    if (!draggingInfo.continues) {
      draggingInfo.dragModel.isMoving = false;
      newPosition = roundToNearestMultipleOfHeight(newPosition);
      newHeight = roundToNearestMultipleOfHeight(newHeight);
      save();
    }
    notifyListeners();
    if (newHeight <= maxHeight && newHeight >= hourHeight / 2) {
      draggingInfo.dragModel.height = newHeight;
      draggingInfo.dragModel.y = newPosition;

      if (!draggingInfo.continues) {
        draggingInfo.dragModel
            .fixActivityModel(panelHeight, hourHeight, dailyModel.wakeTime);
        rearrangeOthers(draggingInfo.dragModel);
        notifyListeners();
        return;
      }
    }
  }

  void onResizeBottom(DraggingInfo draggingInfo) {
    double initialHeight = draggingInfo.dragModel.height;
    double newHeight = initialHeight + draggingInfo.dy;
    double maxHeight = DragItem.dragItemMaxHeight;
    draggingInfo.dragModel.isMoving = true;
    if (!draggingInfo.continues) {
      draggingInfo.dragModel.isMoving = false;
      newHeight = roundToNearestMultipleOfHeight(newHeight);
      save();
    }

    notifyListeners();
    if (newHeight <= maxHeight && newHeight >= hourHeight / 2) {
      draggingInfo.dragModel.height = newHeight;
      if (!draggingInfo.continues) {
        draggingInfo.dragModel
            .fixActivityModel(panelHeight, hourHeight, dailyModel.wakeTime);
        rearrangeOthers(draggingInfo.dragModel);
        notifyListeners();
        return;
      }
    }
  }

  void rearrangeOthers(DragModel mainItem) {
    dragModels.sort((a, b) => a.y.compareTo(b.y));

    double bottomDiffHeight = 0;
    double topDiffHeight = 0;

    for (DragModel otherModel in dragModels
        .where((element) => element.y <= mainItem.y)
        .toList()
        .reversed) {
      if (otherModel == mainItem) {
        continue;
      }
      if (mainItem.y - otherModel.y < otherModel.height + bottomDiffHeight) {
        otherModel.y = mainItem.y - otherModel.height - bottomDiffHeight;
        bottomDiffHeight += otherModel.height;
        if (otherModel.y < 0) {
          otherModel.y = 0;
        }
        otherModel.fixActivityModel(
            panelHeight, hourHeight, dailyModel.wakeTime);
      }
    }

    for (DragModel otherModel
        in dragModels.where((element) => element.y > mainItem.y).toList()) {
      if (otherModel.y - mainItem.y < mainItem.height + topDiffHeight) {
        otherModel.y = mainItem.y + mainItem.height + topDiffHeight;
        topDiffHeight += otherModel.height;

        if (otherModel.y + otherModel.height > panelHeight - hourHeight / 2) {
          otherModel.y = roundToNearestMultipleOfHeight(
              panelHeight - otherModel.height - hourHeight / 2);
        }
        otherModel.fixActivityModel(
            panelHeight, hourHeight, dailyModel.wakeTime);
      }
    }
    checkOverlaps();
  }

  void checkOverlaps() {
    overlaps.clear();
    for (int i = 0; i < dragModels.length; i++) {
      for (int j = i + 1; j < dragModels.length; j++) {
        DragModel model1 = dragModels[i];
        DragModel model2 = dragModels[j];

        double minY = model1.y > model2.y ? model1.y : model2.y;
        double maxY = (model1.y + model1.height) < (model2.y + model2.height)
            ? (model1.y + model1.height)
            : (model2.y + model2.height);

        if (maxY > minY) {
          double overlappingY = minY;
          double overlappingHeight = maxY - minY;

          if (overlappingHeight < 5) continue;
          overlaps.add(Offset(overlappingHeight, overlappingY));
        }
      }
    }
  }

  void initializePuzzlePieces() {
    for (ActivityModel activityModel in dailyModel.activities) {
      DragModel<int> dragModel = DragModel(
        height: 0,
        y: 0,
        activityModel: activityModel,
        isMoving: false,
      );
      dragModel.fixDragModel(panelHeight, hourHeight, dailyModel.wakeTime);
      dragModels.add(dragModel);
    }

    notifyListeners();
    // setState(() {
    //   sleepWakeChanged = true;
    //   initialized = true;
    // });
  }

  void createNewDraggableFromTemplates(TemplateModel templateModel) {
    RoutineModel routine = templateModel.toRoutine();
    if (templateModel.durations[dailyModel.date.weekday - 1].isEmpty) {
      return;
    }

    if (dragModels
        .map((e) => e.activityModel)
        .toList()
        .any((activity) => activity.templateId == templateModel.id)) {
      return;
    }

    Duration duration = Duration(
        minutes: templateModel
                .durations[dailyModel.date.weekday - 1][1].inMinutes -
            templateModel.durations[dailyModel.date.weekday - 1][0].inMinutes);
    Duration time = Duration(
        minutes:
            templateModel.durations[dailyModel.date.weekday - 1][0].inMinutes);

    DragModel<int> dragModel = DragModel(
        height: 0,
        y: 0,
        isMoving: false,
        activityModel: ActivityModel(
          id: routine.id,
          time: time,
          date: dailyModel.date,
          duration: duration,
          title: routine.title,
          iconPath: routine.iconPath,
          color: routine.color,
          fromTemplate: true,
          templateId: templateModel.id,
          reminders: [],
        ));
    dragModel.fixDragModel(panelHeight, hourHeight, dailyModel.wakeTime);
    dragModels.add(dragModel);
    save();
    notifyListeners();
  }

  void fixDragModels() {
    for (DragModel dragModel in dragModels) {
      dragModel.fixDragModel(panelHeight, hourHeight, dailyModel.wakeTime);
    }
  }

  void updateNewDraggablePos(
      {double? startPos, double? dy, double? updatedPos}) {
    assert(!(startPos == null && dy == null && updatedPos == null),
        "Both pos and dy is empty");

    if (startPos != null) {
      newDraggableStartPos = startPos;
      newDraggableEndPos = startPos;
      notifyListeners();
      return;
    } else if (updatedPos != null) {
      newDraggableEndPos = updatedPos;
      notifyListeners();
      return;
    }

    newDraggableEndPos += dy!;
    notifyListeners();
    return;
  }

  void handleNewDraggable(BuildContext context) {
    double height =
        min(hourHeight * 6, (newDraggableEndPos - newDraggableStartPos).abs());
    double y = newDraggableStartPos < newDraggableEndPos
        ? newDraggableStartPos
        : newDraggableStartPos - height;
    double heightRounded = roundToNearestMultipleOfHeight(height);
    double yRounded = roundToNearestMultipleOfHeight(y);
    if (heightRounded == 0) {
      return;
    }

    Duration activityTime = DragModel.findActivityTime(
        yRounded, panelHeight, hourHeight, dailyModel.wakeTime);
    Duration activityDuration = DragModel.findActivityDuration(
        heightRounded, panelHeight, hourHeight, dailyModel.wakeTime);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskCreatePanel(
        panelDate: dailyModel.date,
        initialTime: activityTime,
        initialDuration: activityDuration,
        onCreate: (ActivityModel activityModel) {
          DragModel<int> dragModel = DragModel(
            height: heightRounded,
            y: yRounded,
            activityModel: activityModel,
            isMoving: false,
          );
          dragModel.fixDragModel(panelHeight, hourHeight, dailyModel.wakeTime);
          onDrag(
            DraggingInfo(
                dy: 0,
                continues: false,
                lastTappedY: dragModel.y,
                dragModel: dragModel),
          );
          dragModels.add(dragModel);
          rearrangeOthers(dragModel);
          save();
          NotificationService().manageActivityNotifications(activityModel);
          notifyListeners();
        },
      ),
    ).whenComplete(() {
      newDraggableEndPos = 0;
      newDraggableStartPos = 0;
      notifyListeners();
    });
    //TODO panel
  }

  //////////////////////
  void createNewDraggableFromRoutines() {
    RoutineModel routine = draggingRoutine!.routineModel;
    DragModel<int> dragModel = DragModel(
        height: (draggingRoutine!.routineModel.duration.inMinutes / 60) *
            draggingRoutine!.hourHeight,
        y: draggingRoutine!.globalPos.dy -
            stackHeightDiff -
            TimePanel.panelFixedTabHeight +
            draggingRoutine!.hourHeight / 2 -
            (hourHeight / 4) *
                (draggingRoutine!.routineModel.duration.inMinutes / 30),
        isMoving: false,
        activityModel: ActivityModel(
            date: dailyModel.date,
            id: IdUtil.generateIntId(),
            time: const Duration(hours: 0),
            duration: routine.duration,
            title: routine.title,
            iconPath: routine.iconPath,
            color: routine.color,
            reminders: []));
    dragModel.fixActivityModel(
        panelHeight, draggingRoutine!.hourHeight, dailyModel.wakeTime);
    dragModel.fixDragModel(
        panelHeight, draggingRoutine!.hourHeight, dailyModel.wakeTime);
    dragModels.add(dragModel);
    rearrangeOthers(dragModel);
    draggingRoutine = null;
    save();
    notifyListeners();
  }

  updateDraggableInfo(DraggableRoutineInfo draggableInfo) {
    if (draggableInfo.dragging) {
      draggingRoutine = draggableInfo;
      notifyListeners();
      return;
    }
    if (draggingRoutine!.globalPos.dx < 90 &&
        10 < draggingRoutine!.globalPos.dx) {
      createNewDraggableFromRoutines();
    } else {
      draggingRoutine = null;
      notifyListeners();
    }
  }

  void onDeleteDraggable(DragModel dragModel) {
    dragModels.remove(dragModel);
    checkOverlaps();
    NotificationService().deleteActivityNotifications(dragModel.activityModel);
    save();
    notifyListeners();
  }

  void onActivityStatusChanged(DragModel dragModel, bool status) {
    dragModel.activityModel.isDone = status;
    save();
    notifyListeners();
  }

  templateStatusChanged(bool status, {bool initialization = false}) {
    if (!status) {
      dragModels.removeWhere((element) => element.activityModel.fromTemplate);
    } else {
      for (var template in Program().templates) {
        createNewDraggableFromTemplates(template);
      }
    }

    if (!initialization) {
      isTemplatesActive = status;
    }
    notifyListeners();
  }

  void updateDayTime(Duration sleepTime, Duration wakeTime) {
    dailyModel.sleepTime = sleepTime;
    dailyModel.wakeTime = wakeTime;
    fixDragModels();
    notifyListeners();
    NotificationService().manageDailyNotifications();
    save();
  }

  void save() {
    dailyModel.activities.clear();
    dailyModel.activities
        .addAll(dragModels.map((e) => e.activityModel).toList());
    LocalService().saveDay(dailyModel);
  }

  void handleEditActivity(BuildContext context, ActivityModel activityModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskCreatePanel(
        panelDate: dailyModel.date,
        initialTime: activityModel.time,
        initialDuration: activityModel.duration,
        editedActivity: activityModel,
        onEdit: (ActivityModel activityModel) {
          DragModel dragModel = dragModels
              .firstWhere((drag) => drag.activityModel.id == activityModel.id);
          dragModel.activityModel = activityModel;
          dragModel.fixDragModel(panelHeight, hourHeight, dailyModel.wakeTime);
          rearrangeOthers(dragModel);
          save();
          NotificationService().deleteActivityNotifications(activityModel);
          NotificationService().manageActivityNotifications(activityModel);
          notifyListeners();
        },
      ),
    ).whenComplete(() {
      newDraggableEndPos = 0;
      newDraggableStartPos = 0;
      notifyListeners();
    });
  }
}
