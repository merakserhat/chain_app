import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/home/widgets/time_panel/routine_circle.dart';
import 'package:flutter/material.dart';

class DraggableRoutineCircle extends StatelessWidget {
  const DraggableRoutineCircle({
    Key? key,
    required this.hourHeight,
    required this.routine,
    required this.dragged,
  }) : super(key: key);

  final double hourHeight;
  final RoutineModel routine;
  final Function(DraggableRoutineInfo) dragged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (info) {
          dragged(DraggableRoutineInfo(
            globalPos:
                calculateCenterPos(info.globalPosition, info.localPosition),
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onTapUp: (info) {
          dragged(DraggableRoutineInfo(
            globalPos:
                calculateCenterPos(info.globalPosition, info.localPosition),
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        onVerticalDragUpdate: (info) {
          dragged(DraggableRoutineInfo(
            globalPos: calculateCenterPos(
                info.globalPosition, Offset(hourHeight / 2, hourHeight / 2)),
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onHorizontalDragUpdate: (info) {
          dragged(DraggableRoutineInfo(
            globalPos: calculateCenterPos(
                info.globalPosition, Offset(hourHeight / 2, hourHeight / 2)),
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onVerticalDragEnd: (info) {
          dragged(DraggableRoutineInfo(
            globalPos: calculateCenterPos(
                info.velocity.pixelsPerSecond, info.velocity.pixelsPerSecond),
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        onHorizontalDragEnd: (info) {
          dragged(DraggableRoutineInfo(
            globalPos: calculateCenterPos(
                info.velocity.pixelsPerSecond, info.velocity.pixelsPerSecond),
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        child: RoutineCircle(
          hourHeight: hourHeight,
          routine: routine,
        ));
  }

  Offset calculateCenterPos(Offset globalPos, Offset localPos) {
    return Offset(globalPos.dx - localPos.dx, globalPos.dy - localPos.dy);
  }
}

class DraggableRoutineInfo {
  Offset globalPos;
  RoutineModel routineModel;
  double hourHeight;
  bool dragging;

  DraggableRoutineInfo({
    required this.globalPos,
    required this.routineModel,
    required this.hourHeight,
    this.dragging = true,
  });
}
