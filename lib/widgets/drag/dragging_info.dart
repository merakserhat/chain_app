import 'drag_model.dart';

class DraggingInfo {
  double dy;
  bool continues;
  double lastTappedY;
  DragModel dragModel;

  DraggingInfo({
    required this.dy,
    required this.continues,
    required this.lastTappedY,
    required this.dragModel,
  });
}
