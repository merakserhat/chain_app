import 'dart:convert';

import 'package:chain_app/models/routine_model.dart';
import 'package:hive_flutter/adapters.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();

  late final String routineBoxName = "routines";
  late final String habitBoxName = "habits";

  factory LocalService() {
    return _instance;
  }

  Future init() async {
    await Hive.openBox(routineBoxName);
    await Hive.openBox(habitBoxName);
  }

  LocalService._internal() {
    // initialization logic
  }

  ///Gets routines as a list
  List<RoutineModel> loadRoutines() {
    Box routineBox = Hive.box("routines");
    List<RoutineModel> routines = [];

    for (String key in routineBox.keys) {
      final surahMap =
          json.decode(json.encode(routineBox.get(key))) as Map<String, dynamic>;

      RoutineModel routineModel = RoutineModel.fromJson(surahMap);
      routines.add(routineModel);
    }
    return routines;
  }

  List<RoutineModel> saveRoutines(List<RoutineModel> routines) {
    Box routineBox = Hive.box("routines");

    // save not exists
    for (int i = 0; i < routines.length; i++) {
      if (!routineBox.keys.contains(routines[i].id)) {
        routineBox.put(routines[i].id, routines[i].toJson());
      }
    }

    List<String> routineIds = routines.map((e) => e.id).toList();
    List savedRoutineIds = routineBox.keys.toList();
    for (int i = 0; i < savedRoutineIds.length; i++) {
      if (!routineIds.contains(savedRoutineIds[i])) {
        routineBox.delete(savedRoutineIds[i]);
      }
    }

    return routines;
  }
  /*
    save routines
    load routines

    save templates
    load templates

    save day
    get day
   */
}
