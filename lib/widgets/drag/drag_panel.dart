import 'dart:math';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:flutter/material.dart';

import 'drag_item.dart';
import 'drag_model.dart';
import 'dragging_info.dart';

class DragPanel extends StatefulWidget {
  const DragPanel({
    Key? key,
    required this.hourHeight,
    required this.dragModels,
    required this.panelHeight,
    required this.wakeTime,
  }) : super(key: key);

  final double hourHeight;
  final Duration wakeTime;
  final double panelHeight;
  final List<DragModel<int>> dragModels;

  @override
  State<DragPanel> createState() => _DragPanelState();
}

class _DragPanelState extends State<DragPanel> {
  late List<DragModel<int>> _dragModels;
  final List<Offset> overlaps = [];

  double newDraggableStartPos = 0;
  double newDraggableEndPos = 0;

  @override
  void initState() {
    super.initState();
    _dragModels = widget.dragModels;
  }

  void onResizeTop(DraggingInfo draggingInfo) {
    double currentPosition = draggingInfo.dragModel.y;
    double currentHeight = draggingInfo.dragModel.height;
    double maxHeight = DragItem.dragItemMaxHeight;
    double newPosition = currentPosition + draggingInfo.dy;
    double newHeight = currentHeight - draggingInfo.dy;
    if (!draggingInfo.continues) {
      newPosition = roundToNearestMultipleOfHeight(newPosition);
      newHeight = roundToNearestMultipleOfHeight(newHeight);
    }
    if (newHeight <= maxHeight && newHeight >= widget.hourHeight / 2) {
      draggingInfo.dragModel.height = newHeight;
      draggingInfo.dragModel.y = newPosition;

      if (!draggingInfo.continues) {
        draggingInfo.dragModel.fixActivityModel(
            widget.panelHeight, widget.hourHeight, widget.wakeTime);
        rearrangeOthers(draggingInfo.dragModel);
        return;
      }
      setState(() {});
    }
  }

  void onResizeBottom(DraggingInfo draggingInfo) {
    double initialHeight = draggingInfo.dragModel.height;
    double newHeight = initialHeight + draggingInfo.dy;
    double maxHeight = DragItem.dragItemMaxHeight;
    if (!draggingInfo.continues) {
      newHeight = roundToNearestMultipleOfHeight(newHeight);
    }

    if (newHeight <= maxHeight && newHeight >= widget.hourHeight / 2) {
      draggingInfo.dragModel.height = newHeight;

      if (!draggingInfo.continues) {
        draggingInfo.dragModel.fixActivityModel(
            widget.panelHeight, widget.hourHeight, widget.wakeTime);
        rearrangeOthers(draggingInfo.dragModel);
        return;
      }
      setState(() {});
    }
  }

  double roundToNearestMultipleOfHeight(double number) {
    double roundDifference = number % (widget.hourHeight / 2);
    double rounded2 = number - roundDifference;
    if (roundDifference > widget.hourHeight / 4) {
      rounded2 += widget.hourHeight / 2;
    }
    return max(0, rounded2);
  }

  void onDrag(DraggingInfo draggingInfo) {
    draggingInfo.dragModel.y += draggingInfo.dy;

    if (!draggingInfo.continues) {
      draggingInfo.dragModel.y =
          roundToNearestMultipleOfHeight(draggingInfo.dragModel.y).toDouble();
      if (draggingInfo.dragModel.y + draggingInfo.dragModel.height >
          widget.panelHeight - widget.hourHeight / 2) {
        draggingInfo.dragModel.y = roundToNearestMultipleOfHeight(
            widget.panelHeight -
                draggingInfo.dragModel.height -
                widget.hourHeight / 2);
      }
      draggingInfo.dragModel.fixActivityModel(
          widget.panelHeight, widget.hourHeight, widget.wakeTime);
      rearrangeOthers(draggingInfo.dragModel);
      return;
    }
    setState(() {});
  }

  void rearrangeOthers(DragModel mainItem) {
    _dragModels.sort((a, b) => a.y.compareTo(b.y));

    double bottomDiffHeight = 0;
    double topDiffHeight = 0;

    for (DragModel otherModel in _dragModels
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
            widget.panelHeight, widget.hourHeight, widget.wakeTime);
      }
    }

    for (DragModel otherModel
        in _dragModels.where((element) => element.y > mainItem.y).toList()) {
      if (otherModel.y - mainItem.y < mainItem.height + topDiffHeight) {
        otherModel.y = mainItem.y + mainItem.height + topDiffHeight;
        topDiffHeight += otherModel.height;

        if (otherModel.y + otherModel.height >
            widget.panelHeight - widget.hourHeight / 2) {
          otherModel.y = roundToNearestMultipleOfHeight(
              widget.panelHeight - otherModel.height - widget.hourHeight / 2);
        }
        otherModel.fixActivityModel(
            widget.panelHeight, widget.hourHeight, widget.wakeTime);
      }
    }
    checkOverlaps();
    setState(() {});
  }

  void checkOverlaps() {
    overlaps.clear();
    for (int i = 0; i < _dragModels.length; i++) {
      for (int j = i + 1; j < _dragModels.length; j++) {
        DragModel model1 = _dragModels[i];
        DragModel model2 = _dragModels[j];

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: widget.hourHeight / 4),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: (info) {
                newDraggableStartPos = info.localPosition.dy;
                newDraggableEndPos = info.localPosition.dy;
              },
              onVerticalDragUpdate: (info) {
                setState(() {
                  newDraggableEndPos += info.delta.dy;
                });
              },
              onVerticalDragEnd: (info) {
                handleNewDraggable();
              },
              child: Stack(
                children: [
                  for (var dragModel in _dragModels)
                    Positioned(
                      left: 50,
                      top: dragModel.y,
                      child: DragItem(
                        dragModel: dragModel,
                        onResizeTop: onResizeTop,
                        onResizeBottom: onResizeBottom,
                        onDrag: onDrag,
                        dragItemWidth: widget.hourHeight,
                        isPartial: dragModel.height < widget.hourHeight - 1,
                        resizeHeight: max(5, dragModel.height * 0.25),
                      ),
                    ),
                  getNewDraggablePreview(),
                  for (var overlap in overlaps)
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  getNewDraggablePreview() {
    double height = min(widget.hourHeight * 6,
        (newDraggableEndPos - newDraggableStartPos).abs());
    double y = newDraggableStartPos < newDraggableEndPos
        ? newDraggableStartPos
        : newDraggableStartPos - height;

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
  }

  void handleNewDraggable() {
    double height = min(widget.hourHeight * 6,
        (newDraggableEndPos - newDraggableStartPos).abs());
    double y = newDraggableStartPos < newDraggableEndPos
        ? newDraggableStartPos
        : newDraggableStartPos - height;
    double heightRounded = roundToNearestMultipleOfHeight(height);
    double yRounded = roundToNearestMultipleOfHeight(y);
    setState(() {
      newDraggableEndPos = 0;
      newDraggableStartPos = 0;
    });
    if (heightRounded == 0) {
      return;
    }

    DragModel<int> dragModel = DragModel(
      height: heightRounded,
      y: yRounded,
      color: Colors.blueAccent,
      item: 1,
      activityModel: ActivityModel.getBaseActivity(),
    );
    _dragModels.add(dragModel);
    rearrangeOthers(dragModel);
    setState(() {});

    //TODO panel
  }
}
