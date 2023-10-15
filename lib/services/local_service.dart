import 'dart:convert';

import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/daily_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:hive_flutter/adapters.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();

  late final String routineBoxName = "routines";
  late final String habitBoxName = "habits";
  late final String dailyBoxName = "dailies";

  factory LocalService() {
    return _instance;
  }

  Future init() async {
    await Hive.openBox(routineBoxName);
    await Hive.openBox(habitBoxName);
    await Hive.openBox(dailyBoxName);
  }

  LocalService._internal() {
    // initialization logic
  }

  ///Gets routines as a list
  List<RoutineModel> loadRoutines() {
    Box routineBox = Hive.box("routines");
    List<RoutineModel> routines = [];

    for (String key in routineBox.keys) {
      final routineMap =
          json.decode(json.encode(routineBox.get(key))) as Map<String, dynamic>;

      RoutineModel routineModel = RoutineModel.fromJson(routineMap);
      routines.add(routineModel);
    }
    return routines;
  }

  Future<List<RoutineModel>> saveRoutines(List<RoutineModel> routines) async {
    Box routineBox = Hive.box("routines");

    // save not exists
    for (int i = 0; i < routines.length; i++) {
      if (!routineBox.keys.contains(routines[i].id)) {
        await routineBox.put(routines[i].id, routines[i].toJson());
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

  Future<bool> saveDay(DailyModel dailyModel) async {
    Box dailyBox = Hive.box("dailies");

    await dailyBox.put(dailyModel.id, dailyModel.toJson());

    return true;
  }

  DailyModel? loadDaily(DateTime dateTime) {
    Box dailyBox = Hive.box("dailies");
    // dailyBox.clear();
    String id = DailyModel.produceDailyId(dateTime);

    var retrievedItem = dailyBox.get(id);
    print(retrievedItem);

    if (retrievedItem == null) {
      return null;
    }

    final dailyMap =
        json.decode(json.encode(retrievedItem)) as Map<String, dynamic>;

    return DailyModel.fromJson(dailyMap);
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
