import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer(
      {super.key, this.height, this.width, this.backgorundColor});

  final double? height;
  final double? width;
  final Color? backgorundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgorundColor,
      ),
      height: height,
      width: width,

    );
  }
}
