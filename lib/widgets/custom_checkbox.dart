import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final Function(bool?) change;
  final bool isChecked;
  final Color color;
  final String text;

  const CustomCheckbox({
    super.key,
    required this.change,
    required this.isChecked,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          change(!isChecked);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: AppColors.dark400),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: change,
                    activeColor: color,
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(
                          width: 1.0,
                          color: isChecked
                              ? Colors.transparent
                              : AppColors.dark400),
                    ),
                    checkColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
