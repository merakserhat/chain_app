import 'dart:math';

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
  static const double dragItemMaxHeight = 200;
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
    if (widget.isPartial) {
      print("changed");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: _getRoundBoxShape());
  }

  void _informDragMovement(double dy, bool continues) {
    DraggingInfo draggingInfo = DraggingInfo(
      dy: dy,
      continues: continues,
      lastTappedY: lastTappedY,
      dragModel: widget.dragModel,
    );
    print(widget.dragModel.height);

    if (lastTappedY < widget.resizeHeight) {
      widget.onResizeTop(draggingInfo);
    } else if (lastTappedY > lastTappedHeight - widget.resizeHeight) {
      widget.onResizeBottom(draggingInfo);
    } else {
      widget.onDrag(draggingInfo);
    }
  }

  Widget _getRoundBoxShape() {
    if (widget.isPartial) {
      return Container(
        height: widget.dragModel.height,
        width: widget.dragItemWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: widget.dragModel.color),
      );
    }

    double centerBoxHeight = widget.dragModel.height - widget.dragItemWidth;
    double centerBoxY = widget.dragModel.height / 2 - centerBoxHeight / 2;
    return SizedBox(
      width: widget.dragItemWidth,
      height: widget.dragModel.height,
      child: Stack(
        children: [
          Container(
            width: widget.dragItemWidth,
            height: widget.dragItemWidth,
            decoration: BoxDecoration(
              color: widget.dragModel.color,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Positioned(
            top: centerBoxY,
            child: Container(
              width: widget.dragItemWidth,
              height: centerBoxHeight,
              color: widget.dragModel.color,
            ),
          ),
          Positioned(
            top: widget.dragModel.height - widget.dragItemWidth,
            child: Container(
              width: widget.dragItemWidth,
              height: widget.dragItemWidth,
              decoration: BoxDecoration(
                color: widget.dragModel.color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          )
        ],
      ),
    );
  }
}
