import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key, required this.isOpen, required this.onClicked})
      : super(key: key);

  final bool isOpen;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClicked,
      child: Row(
        children: [
          Text(
            "May",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(width: 4),
          Text(
            "13",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: AppColors.primary),
          ),
          Icon(
            isOpen
                ? Icons.arrow_drop_up_outlined
                : Icons.arrow_drop_down_outlined,
          )
        ],
      ),
    );
  }
}
