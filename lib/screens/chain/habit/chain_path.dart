import 'package:chain_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class ChainPath extends StatelessWidget {
  const ChainPath({Key? key}) : super(key: key);

  final int numCircle = 6;
  final int horizontalPadSize = 80;
  final double circleSize = 32;
  final double pathSize = 40;
  final double pathHeight = 22;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - horizontalPadSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            numCircle - 1,
            (index) => Positioned(
              left: calculatePathPos(index, context),
              child: SizedBox(
                  height: pathHeight,
                  width: pathSize,
                  child: Image.asset(
                    "assets/images/path.png",
                    fit: BoxFit.fill,
                    color: AppColors.pathGreen,
                  )),
            ),
          ),
          ...List.generate(
            numCircle,
            (index) => Positioned(
              left: calculateChainPos(index, context),
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text("11",
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateChainPos(int index, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double columnWidth = (width - horizontalPadSize) / numCircle;
    return index * columnWidth + columnWidth / 2 - circleSize / 2;
  }

  double calculatePathPos(int index, BuildContext context) {
    double x1 = calculateChainPos(index, context);
    double x2 = calculateChainPos(index + 1, context) + circleSize;

    return x1 + (x2 - x1) / 2 - pathSize / 2;
  }
}
