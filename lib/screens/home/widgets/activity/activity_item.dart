import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/screens/home/widgets/activity/activity_done_circle.dart';
import 'package:chain_app/screens/home/widgets/activity/line_animated_text.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  ActivityItem({
    super.key,
    required this.activityModel,
    required this.onStatusChanged,
  });

  final ActivityModel activityModel;
  final Function(bool) onStatusChanged;
  final GlobalKey animatedTextKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  LineAnimatedText(
                    text: activityModel.title,
                    isDone: activityModel.isDone,
                    textKey: animatedTextKey,
                    textStyle: Theme.of(context).textTheme.titleMedium!,
                  ),
                  activityModel.fromTemplate
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.lock_clock,
                            color: AppColors.dark400,
                            size: 16,
                          ),
                        )
                      : Container()
                ],
              ),
              Text(
                "${DateUtil.getDurationText(activityModel.time)} - ${DateUtil.getDurationText(Duration(minutes: activityModel.time.inMinutes + activityModel.duration.inMinutes))} (${DateUtil.getDurationText(activityModel.duration, minimize: true)})",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 10, color: AppColors.dark400),
              ),
            ],
          ),
          const Spacer(),
          ActivityDoneCircle(
            color: activityModel.color,
            isDone: activityModel.isDone,
            onStatusChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}
