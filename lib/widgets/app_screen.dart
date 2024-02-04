import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/utils/program.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Program().topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.dark700,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        Program().safeScreenSize = constraints.maxHeight;
        return child;
      })),
    );
  }
}
