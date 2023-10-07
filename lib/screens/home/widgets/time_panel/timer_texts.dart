import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TimerTexts extends StatelessWidget {
  const TimerTexts(
      {Key? key,
      required this.sleepTime,
      required this.wakeTime,
      required this.panelHeight})
      : super(key: key);

  final Duration sleepTime;
  final Duration wakeTime;
  final double panelHeight;
  static const double timerLinePadding = 25;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: List.generate(timeCount, (index) {
            Duration timerDuration =
                Duration(minutes: wakeTime.inMinutes + 30 * index);
            if (timerDuration.inMinutes % 60 != 0) {
              return const Expanded(
                  child: Text(
                "-",
                style: TextStyle(
                  color: AppColors.dark400,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ));
            }
            return Expanded(
                child: Center(
              child: Text(
                DateUtil.getDurationText(timerDuration),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.dark400,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ));
          }),
        ),
        const SizedBox(
          width: timerLinePadding,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              panelHeight ~/ 16,
              (index) => Container(
                    width: 4,
                    height: 7,
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Color(0xff3D3D3D),
                        borderRadius: BorderRadius.circular(120)),
                  )).toList(),
        ),
      ],
    );
  }

  int get timeCount {
    return (sleepTime.inMinutes - wakeTime.inMinutes) ~/ 30 + 1;
  }
}
