import "package:chain_app/constants/app_theme.dart";
import "package:flutter/material.dart";

class ChainButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChainButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/chain.png",
                  width: 18,
                ),
                SizedBox(width: 4),
                Text(
                  "CHAIN",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
