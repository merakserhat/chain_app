import 'package:flutter/material.dart';

class ContentGroup extends StatelessWidget {
  const ContentGroup({
    Key? key,
    required this.label,
    required this.isOpen,
    required this.onChange,
    required this.openPanelHeight,
    required this.child,
  }) : super(key: key);

  final String label;
  final bool isOpen;
  final Function(bool) onChange;
  final double openPanelHeight;

  static const double verticalPadding = 12;
  static const double labelHeight = 40;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: labelHeight,
            child: GestureDetector(
              onTap: () {
                onChange(!isOpen);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      !isOpen
                          ? Icons.arrow_drop_up_outlined
                          : Icons.arrow_drop_down_outlined,
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: isOpen ? openPanelHeight : 0,
            child: child,
          )
        ],
      ),
    );
  }
}
