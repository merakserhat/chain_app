import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/home/widgets/time_panel/routine_circle.dart';
import 'package:chain_app/widgets/drag/drag_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggableRoutineCircle extends StatelessWidget {
  const DraggableRoutineCircle({
    Key? key,
    required this.hourHeight,
    required this.routine,
  }) : super(key: key);

  final double hourHeight;
  final RoutineModel routine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: info.globalPosition,
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onTapUp: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: info.globalPosition,
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        onVerticalDragUpdate: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: info.globalPosition,
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onHorizontalDragUpdate: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: info.globalPosition,
            routineModel: routine,
            hourHeight: hourHeight,
          ));
        },
        onVerticalDragEnd: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: const Offset(0, 0),
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        onHorizontalDragEnd: (info) {
          Provider.of<DragStateModel>(context, listen: false)
              .updateDraggableInfo(DraggableRoutineInfo(
            globalPos: const Offset(0, 0),
            routineModel: routine,
            hourHeight: hourHeight,
            dragging: false,
          ));
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: RoutineCircle(
            hourHeight: hourHeight,
            routine: routine,
          ),
        ));
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
