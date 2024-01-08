import 'dart:math';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/screens/task/task_create_panel.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:chain_app/widgets/drag/drag_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drag_item.dart';
import 'drag_model.dart';
import 'dragging_info.dart';

class DragPanel extends StatefulWidget {
  const DragPanel({
    Key? key,
    required this.hourHeight,
    required this.panelHeight,
    required this.wakeTime,
  }) : super(key: key);

  final double hourHeight;
  final Duration wakeTime;
  final double panelHeight;

  @override
  State<DragPanel> createState() => DragPanelState();
}

class DragPanelState extends State<DragPanel> {
  @override
  void initState() {
    super.initState();
  }

  double roundToNearestMultipleOfHeight(double number) {
    double roundDifference = number % (widget.hourHeight / 2);
    double rounded2 = number - roundDifference;
    if (roundDifference > widget.hourHeight / 4) {
      rounded2 += widget.hourHeight / 2;
    }
    return max(0, rounded2);
  }

  DragStateModel get dragState =>
      Provider.of<DragStateModel>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    // checkOverlaps();
    return Center(
      child: Column(
        children: [
          // SizedBox(height: DragPanel.panelFixedTabHeight),
          SizedBox(height: widget.hourHeight / 4),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (info) {
                dragState.updateNewDraggablePos(
                    startPos: info.localPosition.dy);
              },
              onVerticalDragStart: (info) {
                dragState.updateNewDraggablePos(
                    updatedPos: info.localPosition.dy);
              },
              onVerticalDragUpdate: (info) {
                dragState.updateNewDraggablePos(dy: info.delta.dy);
              },
              onVerticalDragEnd: (info) {
                dragState.handleNewDraggable(context);
              },
              child: Consumer<DragStateModel>(
                  builder: (context, dragState, child) {
                return Stack(
                  children: [
                    for (var dragModel in dragState.dragModels)
                      Positioned(
                        left: 50,
                        top: dragModel.y,
                        child: DragItem(
                          dragModel: dragModel,
                          dragItemWidth: widget.hourHeight,
                          isPartial: dragModel.height < widget.hourHeight - 1,
                          resizeHeight:
                              max(5, min(15, dragModel.height * 0.25)),
                          onDelete: () =>
                              dragState.onDeleteDraggable(dragModel),
                          onEdit: () => dragState.handleEditActivity(
                              context, dragModel.activityModel),
                          onStatusChanged: (status) => dragState
                              .onActivityStatusChanged(dragModel, status),
                        ),
                      ),
                    getNewDraggablePreview(),
                    for (var overlap in dragState.overlaps)
                      Positioned(
                          top: overlap.dy - 12 + overlap.dx / 2,
                          left: 20,
                          child: Center(
                            child: SizedBox(
                                width: 50,
                                height: 24,
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/warning.png",
                                    color: AppColors.secondary,
                                  ),
                                )),
                          ))
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  getNewDraggablePreview() {
    return Consumer<DragStateModel>(builder: (context, dragState, child) {
      double height = min(
          widget.hourHeight * 6,
          (dragState.newDraggableEndPos - dragState.newDraggableStartPos)
              .abs());
      double y = dragState.newDraggableStartPos < dragState.newDraggableEndPos
          ? dragState.newDraggableStartPos
          : dragState.newDraggableStartPos - height;

      double heightRounded = roundToNearestMultipleOfHeight(height);

      if (heightRounded == 0 || widget.hourHeight == 0) {
        return Container();
      }

      Duration prevDuration =
          Duration(minutes: heightRounded ~/ (widget.hourHeight / 2) * 30);

      return Positioned(
        top: y,
        left: 50,
        child: DragItemShape(
          isPartial: height < widget.hourHeight - 1,
          height: height,
          dragItemWidth: widget.hourHeight,
          color: AppColors.dark500,
          child: Text(
            DateUtil.getDurationText(
              prevDuration,
              minimize: true,
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      );
    });
  }
}
