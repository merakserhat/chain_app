import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/models/template_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/chain/routine/routine_onboarding.dart';
import 'package:chain_app/screens/chain/template/template_onboarding.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class TemplateList extends StatelessWidget {
  const TemplateList({
    Key? key,
    required this.routines,
    required this.templates,
    required this.deleteTemplate,
  }) : super(key: key);
  final List<RoutineModel> routines;
  final List<TemplateModel> templates;
  final Function(TemplateModel) deleteTemplate;

  @override
  Widget build(BuildContext context) {
    return _getEmptyTemplate(context);
    // return routines.isEmpty
    //     ? _getEmptyRoutine(context)
    //     : SingleChildScrollView(
    //   child: Column(
    //       children: List.generate(
    //           ((templates.length + 1) / 2).toInt(),
    //               (i) => Row(
    //             children: List.generate(2, (j) {
    //               int routineIndex = 2 * i + j;
    //               if (routineIndex == routines.length) {
    //                 return Expanded(child: Container());
    //               }
    //
    //               return Expanded(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(4.0),
    //                     child: TemplateListItem(
    //                       routineModel: routines[routineIndex],
    //                       isSelected: false,
    //                       enableEdit: true,
    //                       onDelete: () {
    //                         deleteRoutine(routines[routineIndex]);
    //                       },
    //                       onChange: (_) {},
    //                     ),
    //                   ));
    //             }),
    //           ))),
    // );
  }

  Widget _getEmptyTemplate(BuildContext context) {
    // return Container();
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Templates are the constant activities like school, job and etc.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.dark300),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: "Set Templates",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return TemplateOnboarding();
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
