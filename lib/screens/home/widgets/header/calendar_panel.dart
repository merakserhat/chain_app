import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPanel extends StatefulWidget {
  const CalendarPanel({
    Key? key,
    required this.goToDay,
  }) : super(key: key);

  final Function(DateTime) goToDay;

  @override
  State<CalendarPanel> createState() => _CalendarPanelState();
}

class _CalendarPanelState extends State<CalendarPanel> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.dark500, width: 1),
            color: AppColors.dark900,
          ),
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: SizedBox(
              //         width: 24,
              //         child: Image.asset(
              //           "assets/images/cross.png",
              //           color: AppColors.dark300,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              TableCalendar(
                focusedDay: _focusedDay,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: Theme.of(context).textTheme.bodyMedium!,
                  todayTextStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                  todayDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
              ),
              const Spacer(),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: AppButton(
                    label: "Go to Day",
                    onPressed: () => widget.goToDay(_selectedDay),
                    customPadding: const EdgeInsets.symmetric(vertical: 12),
                  )),
              const SizedBox(height: 24),
            ],
          )),
    );
  }
}
