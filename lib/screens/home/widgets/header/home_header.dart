import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/home/widgets/header/chain_button.dart';
import 'package:chain_app/screens/home/widgets/header/header_day.dart';
import 'package:chain_app/screens/home/widgets/header/header_title.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader(
      {Key? key,
      required this.panelDate,
      required this.onDaySelected,
      required this.onWeekChanged})
      : super(key: key);

  final DateTime panelDate;
  final Function(DateTime) onDaySelected;
  final Function(int) onWeekChanged;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final Duration openAnimationDuration = Duration(milliseconds: 200);
  late final PageController _controller;

  bool headerOpen = false;

  final double headerClosedHeight = 60;
  final double headerOpenHeight = 130;
  late double headerHeight;

  final int initialPage = 999;
  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: initialPage,
    );
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: openAnimationDuration,
      padding: EdgeInsets.symmetric(horizontal: 12),
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
                          // showModalBottomSheet(
                          //     context: context,
                          //     isScrollControlled: true,
                          //     builder: (context) => const TaskCreatePanel());
                        }),
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
                  controller: _controller,
                  onPageChanged: (index) {
                    widget.onWeekChanged(index - initialPage);
                  },
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: DateUtil.getWeekDates(DateTime.now()
                            .add(Duration(days: (index - initialPage) * 7)))
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
