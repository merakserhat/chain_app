import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class DeleteWarning extends StatelessWidget {
  const DeleteWarning(
      {Key? key, required this.onDelete, required this.objectName})
      : super(key: key);

  final VoidCallback onDelete;
  final String objectName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 134,
      margin: EdgeInsets.all(16),
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.dark600,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                  child: Center(
                    child: Text(
                      "Are you sure you want to delete this $objectName?",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.dark300),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.dark400, width: 0),
                      ),
                    ),
                    child: Center(
                      child: Text("Delete ${objectName.capitalize()}",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 4,
            width: double.infinity,
            color: Colors.black54,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.dark600,
              ),
              child: Center(
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
