import 'package:chain_app/models/activity_model.dart';
import 'package:equatable/equatable.dart';

class ReminderModel extends Equatable {
  late final int id;
  late final int timeDelayInMinutes;
  late final bool isAfterActivity;
  late final String notificationLabel;
  late final String text;

  ReminderModel({
    required this.id,
    required this.text,
    required this.notificationLabel,
    this.timeDelayInMinutes = 0,
    this.isAfterActivity = false,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['timeDelayInMinutes'] = timeDelayInMinutes;
    data['isAfterActivity'] = isAfterActivity;
    data['notificationLabel'] = notificationLabel;
    data['text'] = text;
    data['id'] = id;
    return data;
  }

  ReminderModel.fromJson(Map<String, dynamic> json) {
    timeDelayInMinutes = json['timeDelayInMinutes'];
    isAfterActivity = json['isAfterActivity'];
    notificationLabel = json['notificationLabel'];
    text = json['text'];
    id = json['id'];
  }

  getNotificationText(ActivityModel activityModel) {
    return notificationLabel.replaceFirst("#", activityModel.title);
  }

  @override
  List<Object?> get props => [text];
}
