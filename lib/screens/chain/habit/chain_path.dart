import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChainPath extends StatelessWidget {
  const ChainPath({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double circleSize = 36;
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: circleSize,
            child: SvgPicture.asset("assets/images/chainPath.svg",
                colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                semanticsLabel: 'Acme Logo'),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ],
      ),
    );
  }
}
