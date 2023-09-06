import "package:chain_app/constants/app_theme.dart";
import "package:flutter/material.dart";

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.dark500,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: color),
            )
          ],
        ),
      ),
    ));
  }
}
