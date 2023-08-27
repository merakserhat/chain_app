import 'package:chain_app/constants/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: List.generate(timeCount, (index) {
            Duration timerDuration =
                Duration(minutes: wakeTime.inMinutes + 30 * index);

            bool disableFirstHour = index == 1 && wakeTime.inMinutes % 60 == 30;
            bool disableLastHour =
                index == timeCount - 2 && sleepTime.inMinutes % 60 == 30;

            if (timerDuration.inMinutes % 60 != 0) {
              return Expanded(
                  child: const Text(
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
                getDurationText(timerDuration),
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
          width: 50 / 2 + 2,
        ),
        Column(
          children: List.generate(
              panelHeight ~/ 16,
              (index) => Container(
                    width: 4,
                    height: 8,
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

  String getDurationText(Duration duration) {
    return "${duration.inHours.toString().padLeft(2, "0")}:${(duration.inMinutes % 60).toString().padLeft(2, "0")}";
  }
}
