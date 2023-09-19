import 'package:flutter/material.dart';

class SlideTable extends StatelessWidget {
  const SlideTable({
    Key? key,
    required this.selectedIndex,
    required this.onChange,
    required this.items,
    required this.height,
  }) : super(key: key);

  final int selectedIndex;
  final Function(int) onChange;
  final List<String> items;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
