import 'package:flutter/material.dart';

class CircularProgressWithCenterWidget extends StatelessWidget {
  final double progress; // Value from 0.0 to 1.0 (e.g., 0.75 for 75%)
  final Widget centerWidget;
  final Color ProgressColor;

   CircularProgressWithCenterWidget({
    Key? key,
    required this.progress,
     required this.centerWidget, required this.ProgressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Centers the child widget
      children: [
        SizedBox(
          width: 75, // Adjust size as needed
          height: 75,
          child: CircularProgressIndicator(
            value: progress, // Progress value
            strokeWidth: 5.0, // Adjust thickness of the circular indicator
            valueColor: AlwaysStoppedAnimation<Color>(ProgressColor), // Color of the progress
            backgroundColor: Colors.grey.shade300, // Color of the remaining part
          ),
        ),
        // Centered widget (Text, Icon, or anything else)
        centerWidget,
      ],
    );
  }
}