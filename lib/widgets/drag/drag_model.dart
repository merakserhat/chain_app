import 'dart:ui';

class DragModel<E> {
  double height;
  double y;
  Color color;
  E item;

  DragModel({
    required this.height,
    required this.y,
    required this.color,
    required this.item,
  });
}
