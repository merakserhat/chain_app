import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
      {Key? key,
      required this.isOpen,
      required this.onClicked,
      required this.panelDate})
      : super(key: key);

  final bool isOpen;
  final VoidCallback onClicked;
  final DateTime panelDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClicked,
      child: Row(
        children: [
          Text(
            DateFormat.MMM().format(panelDate),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat.d().format(panelDate),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: DateUtil.isToday(DateTime.now(), panelDate)
                      ? AppColors.primary
                      : Colors.white,
                ),
          ),
          Icon(
            isOpen
                ? Icons.arrow_drop_up_outlined
                : Icons.arrow_drop_down_outlined,
          )
        ],
      ),
    );
  }
}
