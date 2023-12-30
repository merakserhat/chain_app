import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class HeaderDay extends StatelessWidget {
  const HeaderDay({
    Key? key,
    required this.dateTime,
    required this.panelDate,
    required this.onDaySelected,
  }) : super(key: key);

  final Function(DateTime) onDaySelected;
  final DateTime dateTime;
  final DateTime panelDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDaySelected(dateTime),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateUtil.getAbbreviatedWeekday(dateTime),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.dark300),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: DateUtil.isToday(dateTime, panelDate)
                  ? DateUtil.isToday(dateTime, DateTime.now())
                      ? AppColors.primary
                      : AppColors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                DateUtil.getMonthDay(dateTime),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: DateUtil.isToday(dateTime, panelDate)
                          ? DateUtil.isToday(dateTime, DateTime.now())
                              ? Colors.white
                              : AppColors.dark700
                          : DateUtil.isToday(dateTime, DateTime.now())
                              ? AppColors.primary
                              : AppColors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
