import 'package:chain_app/models/routine_model.dart';
import 'package:flutter/cupertino.dart';

class Program extends ChangeNotifier {
  static final Program _instance = Program._internal();

  factory Program() {
    return _instance;
  }

  Program._internal() {
    // initialization logic
    routines = [];
  }

  late List<RoutineModel> routines;
  void updateRoutines(Function function) {
    function();
    notifyListeners();
    print("notified");
  }
}
