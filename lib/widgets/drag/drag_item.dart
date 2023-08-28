import 'dart:math';

import 'package:chain_app/widgets/drag/drag_item_shape.dart';
import 'package:flutter/material.dart';

import 'drag_model.dart';
import 'dragging_info.dart';

class DragItem extends StatefulWidget {
  const DragItem({
    Key? key,
    required this.dragModel,
    required this.onResizeTop,
    required this.onResizeBottom,
    required this.onDrag,
    required this.dragItemWidth,
    required this.isPartial,
    required this.resizeHeight,
  }) : super(key: key);

  final double dragItemWidth;
  static double dragItemMaxHeight = 200;
  final DragModel<int> dragModel;
  final Function(DraggingInfo) onResizeTop;
  final Function(DraggingInfo) onResizeBottom;
  final Function(DraggingInfo) onDrag;
  final double resizeHeight;
  final bool isPartial;

  @override
  State<DragItem> createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  double lastTappedY = 0;
  double lastTappedHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double newMaxHeight = widget.dragItemWidth * 6;
      if (newMaxHeight != DragItem.dragItemMaxHeight) {
        DragItem.dragItemMaxHeight = newMaxHeight;
      }
    });
    return GestureDetector(
      onTapDown: (details) {
        lastTappedY = details.localPosition.dy;
        lastTappedHeight = widget.dragModel.height;
      },
      onVerticalDragUpdate: (details) {
        _informDragMovement(details.delta.dy, true);
      },
      onVerticalDragEnd: (details) {
        _informDragMovement(0, false);
      },
      child: DragItemShape(
          isPartial: widget.isPartial,
          height: widget.dragModel.height,
          dragItemWidth: widget.dragItemWidth,
          color: widget.dragModel.color),
    );
  }

  void _informDragMovement(double dy, bool continues) {
    DraggingInfo draggingInfo = DraggingInfo(
      dy: dy,
      continues: continues,
      lastTappedY: lastTappedY,
      dragModel: widget.dragModel,
    );
    print("widget.resizeHeight");
    print(widget.resizeHeight);

    if (lastTappedY < widget.resizeHeight) {
      widget.onResizeTop(draggingInfo);
    } else if (lastTappedY > lastTappedHeight - widget.resizeHeight) {
      widget.onResizeBottom(draggingInfo);
    } else {
      widget.onDrag(draggingInfo);
    }
  }
}
