import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/home/widgets/header/chain_button.dart';
import 'package:chain_app/screens/home/widgets/header/header_title.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final Duration openAnimationDuration = Duration(milliseconds: 200);

  bool headerOpen = false;

  final double headerClosedHeight = 60;
  final double headerOpenHeight = 100;
  late double headerHeight;

  @override
  void initState() {
    super.initState();
    headerHeight = headerClosedHeight;
  }

  void handleHeaderClicked() {
    setState(() {
      headerHeight = headerOpen ? headerClosedHeight : headerOpenHeight;
    });
    Future.delayed(openAnimationDuration, () {
      setState(() {
        headerOpen = !headerOpen;
      });
    });
  }

  void handleSettingsClicked() {}

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: openAnimationDuration,
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: headerHeight,
      width: double.infinity,
      child: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (_) {},
          child: Column(
            children: [
              SizedBox(
                height: headerClosedHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderTitle(
                        isOpen: headerOpen, onClicked: handleHeaderClicked),
                    Row(
                      children: [
                        ChainButton(onPressed: () {}),
                        IconButton(
                          onPressed: handleSettingsClicked,
                          icon: const Icon(
                            Icons.settings,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: headerOpenHeight - headerClosedHeight,
              )
            ],
          ),
        ),
      ),
    );
  }
}
