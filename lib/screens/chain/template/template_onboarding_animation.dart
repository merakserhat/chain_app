import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class TemplateOnboardingAnimation extends StatefulWidget {
  const TemplateOnboardingAnimation({Key? key}) : super(key: key);

  @override
  State<TemplateOnboardingAnimation> createState() =>
      _TemplateOnboardingAnimationState();
}

class _TemplateOnboardingAnimationState
    extends State<TemplateOnboardingAnimation> {
  final double dayFinalHeight = 120;
  final double act1FinalHeight = 28;
  double actSpaceHeight = 0;
  double dayHeight = 0;
  double act1Height = 0;
  double act2Height = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          dayHeight = dayFinalHeight;
        });
      }
      Future.delayed(const Duration(milliseconds: 1300), () {
        if (mounted) {
          setState(() {
            act1Height = act1FinalHeight;
            actSpaceHeight = 8;
          });
        }
        Future.delayed(const Duration(milliseconds: 1300), () {
          if (mounted) {
            setState(() {
              act2Height = act1FinalHeight;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dayFinalHeight,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            7,
            (index) => Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    height: dayHeight,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.dark600,
                    ),
                    child: _getActivities(index),
                  ),
                )),
      ),
    );
  }

  Widget _getActivities(int index) {
    switch (index) {
      case 0:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight * 2 + act1Height),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                height: act1Height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark500,
                ),
              ),
            ],
          );
        }
      case 1:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                height: act1Height * 2 + actSpaceHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark500,
                ),
              ),
            ],
          );
        }
      case 2:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark400,
                ),
                height: act2Height,
              ),
              actSpaceHeight == 0
                  ? Container()
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      height: act2Height == 0 && actSpaceHeight != 0
                          ? act1FinalHeight
                          : 0),
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                height: act1Height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark500,
                ),
              )
            ],
          );
        }
      case 3:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark500,
                ),
                height: act1Height * 2 + actSpaceHeight,
              ),
            ],
          );
        }
      case 4:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                height: act1Height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark500,
                ),
              )
            ],
          );
        }
      case 5:
        {
          return Column(
            children: [
              SizedBox(height: actSpaceHeight),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: EdgeInsets.symmetric(horizontal: actSpaceHeight / 4),
                width: double.infinity,
                height: 3 * act2Height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.dark400,
                ),
              ),
            ],
          );
        }
      case 6:
        {
          return Column(
            children: [],
          );
        }
    }

    return Container();
  }
}
