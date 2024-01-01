import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TimerTexts extends StatelessWidget {
  TimerTexts({
    Key? key,
    required this.sleepTime,
    required this.wakeTime,
    required this.panelHeight,
    required this.hourHeight,
  }) : super(key: key);

  final Duration sleepTime;
  final Duration wakeTime;
  final double panelHeight;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Column(
            children: List.generate(timeCount, (index) {
              Duration timerDuration =
                  Duration(minutes: wakeTime.inMinutes + 30 * index);
              if (timerDuration.inMinutes % 60 != 0) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: AppColors.dark400,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
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
                ),
              );
            }),
          ),
        ),
        SizedBox(
          // (2 * margin + width) / 2
          width: hourHeight / 2 - 6,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              panelHeight ~/ 16,
              (index) => Container(
                    width: 4,
                    height: 7,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: const Color(0xff3D3D3D),
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
