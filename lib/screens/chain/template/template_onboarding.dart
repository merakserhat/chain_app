import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/models/routine_model.dart';
import 'package:chain_app/screens/chain/routine/routine_list_item.dart';
import 'package:chain_app/screens/chain/template/template_onboarding_animation.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class TemplateOnboarding extends StatefulWidget {
  const TemplateOnboarding({Key? key}) : super(key: key);

  @override
  State<TemplateOnboarding> createState() => _TemplateOnboardingState();
}

class _TemplateOnboardingState extends State<TemplateOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 48),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.dark700),
            child: Column(
              children: [
                Text(
                  "Which are the following activities you regularly do?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                const TemplateOnboardingAnimation(),
                const SizedBox(height: 32),
                AppButton(
                  label: "Complete",
                  onPressed: () {
                    // List<RoutineModel> selectedRoutines =
                    // selectedIndexes.map((i) => routines[i]).toList();
                    // widget.selectRoutines(selectedRoutines);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
