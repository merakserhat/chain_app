import 'package:equatable/equatable.dart';

class ReminderModel extends Equatable {
  late final int timeDelayInMinutes;
  late final bool isAfterActivity;
  late final String text;

  ReminderModel({
    this.timeDelayInMinutes = 0,
    this.isAfterActivity = false,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['timeDelayInMinutes'] = timeDelayInMinutes;
    data['isAfterActivity'] = isAfterActivity;
    data['text'] = text;
    return data;
  }

  ReminderModel.fromJson(Map<String, dynamic> json) {
    timeDelayInMinutes = json['timeDelayInMinutes'];
    isAfterActivity = json['isAfterActivity'];
    text = json['text'];
  }

  @override
  List<Object?> get props => [text];
}
