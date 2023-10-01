import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:chain_app/screens/chain/habit/chain_path.dart';
import 'package:chain_app/screens/chain/habit/habit_list.dart';
import 'package:chain_app/screens/chain/routine/create_routine_panel.dart';
import 'package:chain_app/screens/chain/routine/routine_list.dart';
import 'package:chain_app/screens/chain/template/create_template_panel.dart';
import 'package:chain_app/screens/chain/template/template_list.dart';
import 'package:chain_app/screens/chain/widgets/content_group.dart';
import 'package:chain_app/utils/program.dart';
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

  List<TemplateModel> templates = [];

  final int numPanel = 2;

  @override
  void initState() {
    super.initState();
    Program().addListener(() => mounted ? setState(() {}) : null);
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
          // ContentGroup(
          //   label: "Habits",
          //   isOpen: isHabitsOpen,
          //   onChange: (isOpen) {
          //     setState(() {
          //       isHabitsOpen = isOpen;
          //     });
          //   },
          //   openPanelHeight: calculatePanelSize(),
          //   onAdd: () {},
          //   child: HabitList(
          //       routines: routines,
          //       selectOnboardingRoutines: (_) {},
          //       deleteRoutine: (habit) {}),
          // ),
          ContentGroup(
            label: "Routines",
            onAdd: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CreateRoutinePanel(
                  initialDuration: const Duration(hours: 2),
                  onCreate: (RoutineModel routineModel) {
                    Program().updateRoutines(
                        () => Program().routines.add(routineModel));
                  },
                ),
              );
            },
            isOpen: isRoutinesOpen,
            onChange: (isOpen) {
              setState(() {
                isRoutinesOpen = isOpen;
              });
            },
            openPanelHeight: calculatePanelSize(),
            child: RoutineList(
              selectOnboardingRoutines: (onboardingRoutines) {
                //TODO: save
                Program().updateRoutines(
                    () => Program().routines = onboardingRoutines);
              },
              deleteRoutine: (routine) {
                Program()
                    .updateRoutines(() => Program().routines.remove(routine));
              },
            ),
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
            onAdd: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CreateTemplatePanel(
                  routines: Program().routines,
                  onCreate: (TemplateModel templateModel) {
                    setState(() {
                      templates.add(templateModel);
                    });
                  },
                ),
              );
            },
            child: TemplateList(
              templates: templates,
              deleteTemplate: (template) {
                setState(() {
                  templates.remove(template);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  double calculatePanelSize() {
    // List<bool> panels = [isHabitsOpen, isRoutinesOpen, isTemplatesOpen];
    List<bool> panels = [isRoutinesOpen, isTemplatesOpen];

    panels.removeWhere((element) => !element);
    int openCount = panels.length;

    if (openCount == 0) {
      return 0;
    }

    double panelsHeight = pageHeight;
    panelsHeight -= (2 * numPanel) * ContentGroup.verticalPadding;
    panelsHeight -= numPanel * ContentGroup.labelHeight;
    panelsHeight -= headerHeight;
    panelsHeight -= 2 * numPanel;

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
