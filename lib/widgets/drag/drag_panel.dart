import 'dart:math';

import 'package:flutter/material.dart';

import 'drag_item.dart';
import 'drag_model.dart';
import 'dragging_info.dart';

class DragPanel extends StatefulWidget {
  const DragPanel(
      {Key? key,
      required this.hourHeight,
      required this.dragModels,
      required this.panelHeight})
      : super(key: key);

  final double hourHeight;
  final double panelHeight;
  final List<DragModel<int>> dragModels;

  @override
  State<DragPanel> createState() => _DragPanelState();
}

class _DragPanelState extends State<DragPanel> {
  late List<DragModel<int>> _dragModels;

  @override
  void initState() {
    super.initState();
    _dragModels = widget.dragModels;
  }

  void onResizeTop(DraggingInfo draggingInfo) {
    double currentPosition = draggingInfo.dragModel.y;
    double initialHeight = draggingInfo.dragModel.height;
    double maxHeight = DragItem.dragItemMaxHeight;
    double newPosition = currentPosition + draggingInfo.dy;
    if (!draggingInfo.continues) {
      newPosition =
          roundToNearestMultipleOfHeight(newPosition.toInt()).toDouble();
    }
    double newHeight = initialHeight + (currentPosition - newPosition);
    if (newHeight <= maxHeight && newHeight >= widget.hourHeight) {
      draggingInfo.dragModel.height = newHeight;
      draggingInfo.dragModel.y = newPosition;

      if (!draggingInfo.continues) {
        rearrangeOthers(draggingInfo.dragModel);
        return;
      }
      setState(() {});
    }
  }

  int roundToNearestMultipleOfHeight(int number) {
    double roundDifference = number % (widget.hourHeight / 2);
    double rounded2 = number - roundDifference;
    if (roundDifference > widget.hourHeight / 4) {
      rounded2 += widget.hourHeight / 2;
    }
    return rounded2.toInt();
  }

  void onResizeBottom(DraggingInfo draggingInfo) {
    double initialHeight = draggingInfo.dragModel.height;
    double newHeight = initialHeight + draggingInfo.dy;
    double maxHeight = DragItem.dragItemMaxHeight;
    if (!draggingInfo.continues) {
      newHeight = roundToNearestMultipleOfHeight(newHeight.toInt()).toDouble();
    }

    if (newHeight <= maxHeight && newHeight >= widget.hourHeight / 2) {
      draggingInfo.dragModel.height = newHeight;

      if (!draggingInfo.continues) {
        rearrangeOthers(draggingInfo.dragModel);
        return;
      }
      setState(() {});
    }
  }

  void onDrag(DraggingInfo draggingInfo) {
    draggingInfo.dragModel.y += draggingInfo.dy;

    if (!draggingInfo.continues) {
      draggingInfo.dragModel.y =
          roundToNearestMultipleOfHeight(draggingInfo.dragModel.y.toInt())
              .toDouble();
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
        .where((element) => element.y < mainItem.y)
        .toList()
        .reversed) {
      if (mainItem.y - otherModel.y < otherModel.height + bottomDiffHeight) {
        otherModel.y = mainItem.y - otherModel.height - bottomDiffHeight;
        bottomDiffHeight += otherModel.height;
      }
    }

    for (DragModel otherModel
        in _dragModels.where((element) => element.y > mainItem.y).toList()) {
      if (otherModel.y - mainItem.y < mainItem.height + topDiffHeight) {
        otherModel.y = mainItem.y + mainItem.height + topDiffHeight;
        topDiffHeight += otherModel.height;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: widget.hourHeight / 4),
          Expanded(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
