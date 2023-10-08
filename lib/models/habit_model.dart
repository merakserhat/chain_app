import 'package:chain_app/models/routine_model.dart';

class HabitModel {
  late final List<DateTime> signDurations;
  late final DateTime startDate;
  late final DateTime? endDate;
  late final RoutineModel routineModel;

  HabitModel({
    required this.routineModel,
    required this.startDate,
    required this.endDate,
    required this.signDurations,
  });

  HabitModel.fromJson(Map<String, dynamic> json) {
    List<String> signDurationStrings =
        List.castFrom<dynamic, String>(json['signDurations']);
    signDurations = signDurationStrings.map((e) => DateTime.parse(e)).toList();
    startDate = json['startDate'];
    endDate = json['endDate'];
    //TODO:
    routineModel = json['routineModels'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['signDurations'] = signDurations.map((e) => e.toString());
    _data['startDate'] = startDate.toString();
    _data['endDate'] = endDate.toString();
    _data['routineModel'] = routineModel.id;
    return _data;
  }
}
