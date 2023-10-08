import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:flutter/cupertino.dart';

class Program extends ChangeNotifier {
  static final Program _instance = Program._internal();

  factory Program() {
    return _instance;
  }

  Program._internal() {
    // initialization logic
    routines = [];
    // routines = LocalService().loadRoutines();
  }

  void init() {
    routines = LocalService().loadRoutines();
  }

  late List<RoutineModel> routines;
  void updateRoutines(Function function) {
    function();
    LocalService().saveRoutines(routines);
    notifyListeners();
    print("notified");
  }
}
