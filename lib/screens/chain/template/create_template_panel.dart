import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/widgets/routine_selector_dropdown.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class CreateTemplatePanel extends StatefulWidget {
  const CreateTemplatePanel({
    Key? key,
    required this.onCreate,
    required this.routines,
  }) : super(key: key);

  final Function(RoutineModel routineModel) onCreate;
  final List<RoutineModel> routines;
  @override
  State<CreateTemplatePanel> createState() => _TaskCreatePanelState();
}

class _TaskCreatePanelState extends State<CreateTemplatePanel> {
  RoutineModel? selectedRoutine;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: AppColors.dark700,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getPanelHeader(context),
                    const SizedBox(height: 8),
                    RoutineSelectorDropdown(
                      routines: widget.routines,
                      onChange: (routine) {
                        setState(() {
                          selectedRoutine = routine;
                        });
                      },
                      selectedRoutine: selectedRoutine,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Create Template",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: _getColor(),
                    customPadding: EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      // String id = const Uuid().v1();
                      // RoutineModel routineModel = RoutineModel(
                      //   id: id,
                      //   showOnPanel: isShow,
                      //   duration: selectedDuration,
                      //   title: taskNameController.text,
                      //   iconPath: selectedTaskIcon.src,
                      //   color: selectedColor,
                      // );
                      // widget.onCreate(routineModel);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    return selectedRoutine?.color ?? AppColors.primary;
  }

  Widget _getPanelHeader(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: AppColors.dark600,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            "Create ",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Template",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: _getColor()),
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
