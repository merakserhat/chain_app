import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class DragItemShape extends StatelessWidget {
  const DragItemShape({
    Key? key,
    required this.isPartial,
    required this.height,
    required this.dragItemWidth,
    required this.color,
    this.updating = false,
    this.iconPath,
    this.child,
  }) : super(key: key);

  final bool isPartial;
  final double height;
  final double dragItemWidth;
  final Color color;
  final bool updating;
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
      child: Stack(
        children: [
          Container(
            width: dragItemWidth,
            height: height,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: getColor(),
              borderRadius: BorderRadius.circular(100),
            ),
            child: iconPath != null
                ? Center(
                    child: Image.asset(
                      iconPath!,
                      color: color,
                    ),
                  )
                : Container(),
          ),
          // Positioned(
          //   top: centerBoxY,
          //   child: Container(
          //     width: dragItemWidth,
          //     height: centerBoxHeight,
          //     color: getColor(),
          //   ),
          // ),
          // Positioned(
          //   top: height - dragItemWidth,
          //   child: Container(
          //     width: dragItemWidth,
          //     height: dragItemWidth,
          //     decoration: BoxDecoration(
          //       color: getColor(),
          //       borderRadius: BorderRadius.circular(100),
          //     ),
          //   ),
          // ),
          child == null
              ? Container()
              : Align(
                  alignment: Alignment.center,
                  child: child,
                )
        ],
      ),
    );
  }

  Color getColor() {
    // return color.withOpacity(updating ? 1 : 0.8);
    return AppColors.dark500.withOpacity(updating ? 1 : 0.8);
  }
}
