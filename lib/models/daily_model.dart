import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:flutter/cupertino.dart';

class DailyModel {
  late String id;
  late List<ActivityModel> activities;
  late Duration wakeTime;
  late Duration sleepTime;
  late DateTime date;

  DailyModel({
    required this.activities,
    required this.wakeTime,
    required this.sleepTime,
    required this.date,
  }) {
    id = DailyModel.produceDailyId(date);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['wakeTime'] = wakeTime.inMinutes;
    _data['sleepTime'] = sleepTime.inMinutes;
    _data['date'] = date.toString();
    _data['id'] = id;
    _data['activities'] = activities.map((e) => e.toJson()).toList();
    return _data;
  }

  DailyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    wakeTime = Duration(minutes: json["wakeTime"]);
    sleepTime = Duration(minutes: json["sleepTime"]);
    date = DateTime.parse(json["date"]);
    activities = List.from(json['activities'])
        .map((e) => ActivityModel.fromJson(e))
        .toList();
  }

  static String produceDailyId(DateTime date) {
    return DateTime(date.year, date.month, date.day).toString();
  }
}
