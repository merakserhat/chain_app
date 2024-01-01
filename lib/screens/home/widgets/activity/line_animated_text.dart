import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class LineAnimatedText extends StatefulWidget {
  const LineAnimatedText({
    super.key,
    required this.text,
    required this.isDone,
    this.textStyle,
    required this.textKey,
  });

  final String text;
  final bool isDone;
  final GlobalKey textKey;
  final TextStyle? textStyle;

  @override
  State<LineAnimatedText> createState() => _LineAnimatedTextState();
}

class _LineAnimatedTextState extends State<LineAnimatedText> {
  final Duration duration = const Duration(milliseconds: 400);
  double width = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double newWidth = widget.textKey.currentContext?.size?.width ?? 0;

      if (newWidth != width) {
        setState(() {
          width = newWidth;
        });
      }
    });
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Text(
          key: widget.textKey,
          widget.text,
          style: widget.textStyle?.copyWith(
              color: widget.isDone ? AppColors.dark400 : AppColors.white),
        ),
        AnimatedContainer(
          height: 2,
          duration: duration,
          color: widget.isDone ? AppColors.dark400 : AppColors.dark300,
          width: widget.isDone ? width : 0,
        )
      ],
    );
  }
}
