import 'package:chain_app/screens/home/widgets/header/home_header.dart';
import 'package:chain_app/screens/home/widgets/time_panel/time_panel.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/app_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime panelDate;
  late final PageController _controller;
  late List<DateTime> dates;
  bool isAnimatingPage = false;

  @override
  void initState() {
    super.initState();
    panelDate = DateTime.now();
    _controller = PageController(
      initialPage: DateTime.now().weekday - 1,
    );
    dates = DateUtil.getWeekDates(panelDate);
  }

  void onDaySelected(DateTime dateTime) {
    if (DateUtil.isToday(dateTime, panelDate)) {
      return;
    }
    Duration animationDuration = Duration(milliseconds: 400);
    setState(() {
      panelDate = dateTime;
      isAnimatingPage = true;
    });
    Future.delayed(animationDuration, () {
      setState(() {
        isAnimatingPage = false;
      });
    });
    int pageIndex = DateUtil.indexInList(dateTime, dates);
    _controller.animateToPage(
      pageIndex,
      duration: animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        child: Center(
      child: Column(
        children: [
          HomeHeader(
            weekList: DateUtil.getWeekDates(panelDate),
            panelDate: panelDate,
            onDaySelected: onDaySelected,
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                if (isAnimatingPage) {
                  return;
                }
                if (DateUtil.inInPanelWeek(
                    dates[index], DateUtil.getWeekDates(panelDate))) {
                  setState(() {
                    panelDate = dates[index];
                  });
                }
              },
              children: dates.map((index) => TimePanel()).toList(),
            ),
          ),
        ],
      ),
    ));
  }
}
