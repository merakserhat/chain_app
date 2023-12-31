import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/activity_model.dart';
import 'package:chain_app/screens/home/widgets/activity/activity_done_circle.dart';
import 'package:chain_app/screens/home/widgets/activity/line_animated_text.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key, required this.activityModel});

  final ActivityModel activityModel;

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  bool isDone = false;
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
              LineAnimatedText(
                text: widget.activityModel.title,
                isDone: isDone,
                textKey: animatedTextKey,
                textStyle: Theme.of(context).textTheme.titleMedium!,
              ),
              Text(
                "${DateUtil.getDurationText(widget.activityModel.time)} - ${DateUtil.getDurationText(Duration(minutes: widget.activityModel.time.inMinutes + widget.activityModel.duration.inMinutes))} (${DateUtil.getDurationText(widget.activityModel.duration, minimize: true)})",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 10, color: AppColors.dark400),
              ),
            ],
          ),
          const Spacer(),
          ActivityDoneCircle(
            color: widget.activityModel.color,
            isDone: isDone,
            onStatusChanged: (status) {
              setState(() {
                isDone = status;
              });
            },
          ),
        ],
      ),
    );
  }
}
