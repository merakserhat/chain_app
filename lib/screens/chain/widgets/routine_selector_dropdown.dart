import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/task/widgets/task_create_base_item.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class RoutineSelectorDropdown extends StatelessWidget {
  const RoutineSelectorDropdown(
      {Key? key,
      this.selectedRoutine,
      required this.routines,
      required this.onChange})
      : super(key: key);

  final RoutineModel? selectedRoutine;
  final List<RoutineModel> routines;
  final Function(RoutineModel?) onChange;
  @override
  Widget build(BuildContext context) {
    return TaskCreateBaseItem(
      label: "Which Routine?",
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Container(
              height: 52,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.dark600,
              ),
              child: const Center(
                child: Text(
                  'Select Routine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark400,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            items: routines
                .map(
                  (item) => DropdownMenuItem<RoutineModel>(
                    value: item,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: RoutineListItem(
                            routineModel: item,
                            isSelected: false,
                            onChange: (_) {}),
                      ),
                    ),
                  ),
                )
                .toList(),
            menuItemStyleData:
                const MenuItemStyleData(height: 56, padding: EdgeInsets.zero),
            value: selectedRoutine,
            onChanged: onChange,
            buttonStyleData: ButtonStyleData(
              height: 70,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              elevation: 0,
              useSafeArea: true,
            ),
          ),
        ),
      ),
    );
  }
}
