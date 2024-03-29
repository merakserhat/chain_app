import 'dart:convert';

import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/models/daily_model.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:hive_flutter/adapters.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();

  late final String routineBoxName = "routines";

  // late final String habitBoxName = "habits";
  late final String dailyBoxName = "dailies";
  late final String templateBoxName = "templates";
  late final String defaultsBoxName = "defaults";

  factory LocalService() {
    return _instance;
  }

  Future init() async {
    await Hive.openBox(routineBoxName);
    // await Hive.openBox(habitBoxName);
    await Hive.openBox(dailyBoxName);
    await Hive.openBox(templateBoxName);
    await Hive.openBox(defaultsBoxName);
  }

  LocalService._internal() {
    // initialization logic
  }

  ///Gets routines as a list
  List<RoutineModel> loadRoutines() {
    Box routineBox = Hive.box("routines");
    // routineBox.clear();
    List<RoutineModel> routines = [];

    for (String key in routineBox.keys) {
      print(key);
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
        await routineBox.put(routines[i].id.toString(), routines[i].toJson());
      }
    }

    List<String> routineIds = routines.map((e) => e.id.toString()).toList();
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

  List<TemplateModel> loadTemplates() {
    Box templateBox = Hive.box(templateBoxName);
    // templateBox.clear();
    List<TemplateModel> templates = [];

    for (String key in templateBox.keys) {
      final templateMap = json.decode(json.encode(templateBox.get(key)))
          as Map<String, dynamic>;

      TemplateModel templateModel = TemplateModel.fromJson(templateMap);
      templates.add(templateModel);
    }
    return templates;
  }

  Future<List<TemplateModel>> saveTemplates(
      List<TemplateModel> templates) async {
    Box templateBox = Hive.box(templateBoxName);

    // save not exists
    for (int i = 0; i < templates.length; i++) {
      if (!templateBox.keys.contains(templates[i].id)) {
        await templateBox.put(templates[i].id, templates[i].toJson());
      }
    }

    List<int> templateIds = templates.map((e) => e.id).toList();
    List savedTemplateIds = templateBox.keys.toList();
    for (int i = 0; i < savedTemplateIds.length; i++) {
      if (!templateIds.contains(savedTemplateIds[i])) {
        templateBox.delete(savedTemplateIds[i]);
      }
    }

    return templates;
  }

  Future<bool> saveDayTime(Duration wakeTime, Duration sleepTime) async {
    Box dailyBox = Hive.box(defaultsBoxName);

    await dailyBox.put("wake", wakeTime.inMinutes);
    await dailyBox.put("sleep", sleepTime.inMinutes);

    return true;
  }

  List<Duration> loadDayTime() {
    Box dailyBox = Hive.box(defaultsBoxName);

    int wakeInMinutes = dailyBox.get("wake") ?? 8 * 60;
    int sleepInMinutes = dailyBox.get("sleep") ?? 24 * 60;

    Duration wakeTime = Duration(minutes: wakeInMinutes);
    Duration sleepTime = Duration(minutes: sleepInMinutes);

    return [wakeTime, sleepTime];
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
