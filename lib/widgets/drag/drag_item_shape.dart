import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class DragItemShape extends StatelessWidget {
  const DragItemShape({
    Key? key,
    required this.isPartial,
    required this.height,
    required this.dragItemWidth,
    required this.color,
    this.iconPath,
    this.child,
    this.isMoving = false,
  }) : super(key: key);

  final bool isPartial;
  final double height;
  final double dragItemWidth;
  final Color color;
  final bool isMoving;
  final String? iconPath;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (isPartial) {
      return Container(
        height: height,
        width: dragItemWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: getColor(),
        ),
        // child: Center(child: child ?? Container()),
      );
    }

    return SizedBox(
      width: dragItemWidth,
      height: height,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(1),
        padding: EdgeInsets.all(child == null ? 8 : 0),
        decoration: BoxDecoration(
          color: getColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: child ??
              (iconPath != null
                  ? Center(
                      child: Image.asset(
                        iconPath!,
                        color: color,
                      ),
                    )
                  : Container()),
        ),
      ),
    );
  }

  Color getColor() {
    // return color.withOpacity(updating ? 1 : 0.8);
    return AppColors.dark500.withOpacity(!isMoving ? 1 : 0.8);
  }
}
