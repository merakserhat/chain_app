import 'package:chain_app/constants/app_constants.dart';
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
  late final PageController weekController;
  bool isAnimatingPage = false;
  Duration animationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    panelDate = DateTime.now();
    _controller = PageController(
      initialPage: AppConstants.initialDayIndex,
    );
    weekController = PageController(
      initialPage: AppConstants.initialWeekIndex,
    );
  }

  void onJumpToPageFromCalender(int weekIndex, DateTime dateTime) {
    if (DateUtil.isToday(dateTime, panelDate)) {
      return;
    }

    setState(() {
      this.weekIndex = weekIndex;
      panelDate = dateTime;
      isAnimatingPage = true;
    });

    _controller
        .animateToPage(
          AppConstants.initialDayIndex +
              (7 * weekIndex) +
              (dateTime.weekday - DateTime.now().weekday),
          duration: animationDuration,
          curve: Curves.easeInOut,
        )
        .then((value) => setState(() => isAnimatingPage = false));
    animateWeekIfNecessary();
  }

  void onWeekChanged(int weekIndex) {
    if (isAnimatingPage) {
      return;
    }
    setState(() {
      this.weekIndex = weekIndex;
      isAnimatingPage = true;
      panelDate = DateTime.now().add(Duration(days: weekIndex * 7));
    });
    _controller
        .animateToPage(
          AppConstants.initialDayIndex +
              (7 * weekIndex) +
              (panelDate.weekday - DateTime.now().weekday),
          duration: animationDuration,
          curve: Curves.easeInOut,
        )
        .then((value) => setState(() => isAnimatingPage = false));
  }

  void onDaySelected(DateTime dateTime) {
    if (DateUtil.isToday(dateTime, panelDate)) {
      return;
    }
    setState(() {
      panelDate = dateTime;
      isAnimatingPage = true;
    });
    _controller
        .animateToPage(
          AppConstants.initialDayIndex +
              (7 * weekIndex) +
              (dateTime.weekday - DateTime.now().weekday),
          duration: animationDuration,
          curve: Curves.easeInOut,
        )
        .then((value) => setState(() {
              isAnimatingPage = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        child: Center(
      child: Column(
        children: [
          HomeHeader(
            panelDate: panelDate,
            weekController: weekController,
            onDaySelected: onDaySelected,
            onWeekChanged: onWeekChanged,
            onJumpToPageFromCalender: onJumpToPageFromCalender,
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                if (isAnimatingPage) {
                  return;
                }

                DateTime calculatedDate = DateUtil.calculateCurrentDateTime(
                    index - AppConstants.initialDayIndex);

                setState(() {
                  panelDate = calculatedDate;
                });

                animateWeekIfNecessary();
              },
              itemBuilder: (context, index) {
                return TimePanel(
                  panelDate: DateUtil.calculateCurrentDateTime(
                      index - AppConstants.initialDayIndex),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  animateWeekIfNecessary() {
    int calculatedWeekIndex = DateUtil.calculateDateWeekIndex(panelDate);
    if (calculatedWeekIndex != weekIndex) {
      setState(() {
        isAnimatingPage = true;
      });
      weekController
          .animateToPage(
            calculatedWeekIndex,
            duration: animationDuration,
            curve: Curves.easeInOut,
          )
          .then(
            (value) => setState(
              () {
                isAnimatingPage = false;
              },
            ),
          );
    }
  }
}
