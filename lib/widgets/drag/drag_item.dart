import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/date_util.dart';
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
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width - 66,
        child: Row(
          children: [
            DragItemShape(
              isPartial: widget.isPartial,
              height: widget.dragModel.height,
              dragItemWidth: widget.dragItemWidth,
              iconPath: widget.dragModel.activityModel.iconPath,
              color: widget.dragModel.activityModel.color,
              isMoving: widget.dragModel.isMoving,
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dragModel.activityModel.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "${DateUtil.getDurationText(widget.dragModel.activityModel.time)} - ${DateUtil.getDurationText(Duration(minutes: widget.dragModel.activityModel.time.inMinutes + widget.dragModel.activityModel.duration.inMinutes))} (${DateUtil.getDurationText(widget.dragModel.activityModel.duration, minimize: true)})",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 10, color: AppColors.dark500),
                ),
              ],
            ),
            Expanded(child: Container()),
            _getDoneCircle(widget.dragModel.activityModel.color, true),
          ],
        ),
      ),
    );
  }

  void _informDragMovement(double dy, bool continues) {
    DraggingInfo draggingInfo = DraggingInfo(
      dy: dy,
      continues: continues,
      lastTappedY: lastTappedY,
      dragModel: widget.dragModel,
    );

    if (lastTappedY < widget.resizeHeight) {
      widget.onResizeTop(draggingInfo);
    } else if (lastTappedY > lastTappedHeight - widget.resizeHeight) {
      widget.onResizeBottom(draggingInfo);
    } else {
      widget.onDrag(draggingInfo);
    }
  }

  Widget _getDoneCircle(Color color, bool done) {
    double size = 20;
    return Container(
      padding: const EdgeInsets.all(2),
      width: size,
      height: size,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
      child: Container(
          padding: EdgeInsets.all(2),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.dark600),
          child: done
              ? Container(
                  padding: EdgeInsets.all(2),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: color),
                )
              : null),
    );
  }
}
