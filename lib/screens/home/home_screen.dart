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
  int weekIndex = 0;
  late final PageController _controller;
  bool isAnimatingPage = false;
  final int initialDayIndex = 999;
  Duration animationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    panelDate = DateTime.now();
    _controller = PageController(
      initialPage: initialDayIndex,
    );
  }

  void onWeekChanged(int weekIndex) {
    Future.delayed(animationDuration, () {
      setState(() {
        isAnimatingPage = false;
      });
    });
    setState(() {
      this.weekIndex = weekIndex;
      isAnimatingPage = true;
      panelDate = DateTime.now().add(Duration(days: weekIndex * 7));
      _controller.animateToPage(
        initialDayIndex +
            (7 * weekIndex) +
            (panelDate.weekday - DateTime.now().weekday),
        duration: animationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  void onDaySelected(DateTime dateTime) {
    print("object");
    if (DateUtil.isToday(dateTime, panelDate)) {
      return;
    }
    setState(() {
      panelDate = dateTime;
      isAnimatingPage = true;
    });
    Future.delayed(animationDuration, () {
      setState(() {
        isAnimatingPage = false;
      });
    });
    _controller.animateToPage(
      initialDayIndex +
          (7 * weekIndex) +
          (dateTime.weekday - DateTime.now().weekday),
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
            panelDate: panelDate,
            onDaySelected: onDaySelected,
            onWeekChanged: onWeekChanged,
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                if (isAnimatingPage) {
                  return;
                }
                print(index);
                setState(() {
                  panelDate = DateUtil.calculateCurrentDateTime(
                      weekIndex, index - initialDayIndex);
                });
              },
              itemBuilder: (context, index) => TimePanel(),
            ),
          ),
        ],
      ),
    ));
  }
}
