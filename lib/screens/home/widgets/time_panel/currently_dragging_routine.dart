import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:chain_app/widgets/drag/drag_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentlyDraggingRoutine extends StatelessWidget {
  const CurrentlyDraggingRoutine({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DragStateModel>(builder: (context, dragState, child) {
      return dragState.draggingRoutine != null &&
              dragState.draggingRoutine!.dragging
          ? Positioned(
              top: dragState.draggingRoutine!.globalPos.dy -
                  dragState.stackHeightDiff +
                  44,
              left: dragState.draggingRoutine!.globalPos.dx,
              child: DragItemShape(
                iconPath: dragState.draggingRoutine!.routineModel.iconPath,
                isPartial:
                    dragState.draggingRoutine!.routineModel.duration.inMinutes <
                        60,
                height: (dragState
                            .draggingRoutine!.routineModel.duration.inMinutes /
                        60) *
                    dragState.draggingRoutine!.hourHeight,
                color: dragState.draggingRoutine!.routineModel.color,
                dragItemWidth: dragState.draggingRoutine!.hourHeight,
                isMoving: true,
              ),
            )
          : Container();
    });
  }
}
