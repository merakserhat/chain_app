import 'package:chain_app/models/routine_model.dart';

class HabitModel {
  final List<DateTime> signDurations;
  final DateTime startDate;
  final DateTime? endDate;
  final RoutineModel routineModel;

  HabitModel({
    required this.routineModel,
    required this.startDate,
    required this.endDate,
    required this.signDurations,
  });
}
