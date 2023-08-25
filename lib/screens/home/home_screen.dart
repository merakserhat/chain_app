import 'package:chain_app/screens/home/widgets/header/home_header.dart';
import 'package:chain_app/screens/home/widgets/time_panel/time_panel.dart';
import 'package:chain_app/widgets/app_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
        child: Center(
      child: Column(
        children: [
          HomeHeader(),
          TimePanel(),
        ],
      ),
    ));
  }
}
