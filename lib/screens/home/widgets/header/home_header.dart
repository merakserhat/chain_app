import 'package:chain_app/constants/app_constants.dart';
import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/chain/chain_panel.dart';
import 'package:chain_app/screens/home/widgets/header/calendar_panel.dart';
import 'package:chain_app/screens/home/widgets/header/chain_button.dart';
import 'package:chain_app/screens/home/widgets/header/header_day.dart';
import 'package:chain_app/screens/home/widgets/header/header_title.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
    required this.panelDate,
    required this.onDaySelected,
    required this.onWeekChanged,
    required this.onJumpToPageFromCalender,
    required this.weekController,
  }) : super(key: key);

  final DateTime panelDate;
  final Function(DateTime) onDaySelected;
  final Function(int) onWeekChanged;
  final Function(int, DateTime) onJumpToPageFromCalender;
  final PageController weekController;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final Duration openAnimationDuration = const Duration(milliseconds: 200);
  bool headerOpen = false;

  final double headerClosedHeight = 60;
  final double headerOpenHeight = 130;
  late double headerHeight;

  @override
  void initState() {
    super.initState();
    headerHeight = headerClosedHeight;
  }

  void handleHeaderClicked() {
    setState(() {
      headerHeight = headerOpen ? headerClosedHeight : headerOpenHeight;
    });
    Future.delayed(openAnimationDuration, () {
      setState(() {
        headerOpen = !headerOpen;
      });
    });
  }

  void handleSettingsClicked() {}

  void handleCalendarClicked() {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      builder: (context) => CalendarPanel(
        goToDay: (DateTime dateTime) {
          int goToPageIndex = DateUtil.calculateDateWeekIndex(dateTime);
          widget.onJumpToPageFromCalender(
              goToPageIndex - AppConstants.initialWeekIndex, dateTime);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: openAnimationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: headerHeight,
      width: double.infinity,
      child: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (_) {},
          child: Column(
            children: [
              SizedBox(
                height: headerClosedHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderTitle(
                      isOpen: headerOpen,
                      onClicked: handleHeaderClicked,
                      panelDate: widget.panelDate,
                    ),
                    Row(
                      children: [
                        ChainButton(onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const ChainPanel());
                        }),
                        IconButton(
                          onPressed: handleCalendarClicked,
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        IconButton(
                          onPressed: handleSettingsClicked,
                          icon: const Icon(
                            Icons.settings,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: headerOpenHeight - headerClosedHeight,
                child: PageView.builder(
                  controller: widget.weekController,
                  onPageChanged: (index) {
                    widget.onWeekChanged(index - AppConstants.initialWeekIndex);
                  },
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: DateUtil.getWeekDates(DateTime.now().add(Duration(
                            days: (index - AppConstants.initialWeekIndex) * 7)))
                        .map(
                          (date) => HeaderDay(
                            onDaySelected: widget.onDaySelected,
                            dateTime: date,
                            panelDate: widget.panelDate,
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
