import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/chain/routine/routine_list.dart';
import 'package:chain_app/screens/chain/widgets/content_group.dart';
import 'package:flutter/material.dart';

class ChainPanel extends StatefulWidget {
  const ChainPanel({Key? key}) : super(key: key);

  @override
  State<ChainPanel> createState() => _ChainPanelState();
}

class _ChainPanelState extends State<ChainPanel> {
  bool isHabitsOpen = true;
  bool isRoutinesOpen = true;
  bool isTemplatesOpen = true;

  late double pageHeight;
  final double headerHeight = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageHeight = MediaQuery.of(context).size.height * 0.92;

    return Container(
      width: double.infinity,
      height: pageHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: AppColors.dark700,
      ),
      child: Column(
        children: [
          _getPanelHeader(context),
          ContentGroup(
            label: "Habits",
            isOpen: isHabitsOpen,
            onChange: (isOpen) {
              setState(() {
                isHabitsOpen = isOpen;
              });
            },
            openPanelHeight: calculatePanelSize(),
            child: Container(),
          ),
          ContentGroup(
            label: "Routines",
            isOpen: isRoutinesOpen,
            onChange: (isOpen) {
              setState(() {
                isRoutinesOpen = isOpen;
              });
            },
            openPanelHeight: calculatePanelSize(),
            child: RoutineList(),
          ),
          ContentGroup(
            label: "Templates",
            isOpen: isTemplatesOpen,
            onChange: (isOpen) {
              setState(() {
                isTemplatesOpen = isOpen;
              });
            },
            openPanelHeight: calculatePanelSize(),
            child: Container(),
          )
        ],
      ),
    );
  }

  double calculatePanelSize() {
    List<bool> panels = [isHabitsOpen, isRoutinesOpen, isTemplatesOpen];

    panels.removeWhere((element) => !element);
    int openCount = panels.length;

    if (openCount == 0) {
      return 0;
    }

    double panelsHeight = pageHeight;
    panelsHeight -= 6 * ContentGroup.verticalPadding;
    panelsHeight -= 3 * ContentGroup.labelHeight;
    panelsHeight -= headerHeight;
    panelsHeight -= 6;

    return panelsHeight / openCount;
  }

  Widget _getPanelHeader(BuildContext context) {
    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: AppColors.dark600,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            "Activity Store",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.close_outlined,
                color: AppColors.dark300,
                size: 36,
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
