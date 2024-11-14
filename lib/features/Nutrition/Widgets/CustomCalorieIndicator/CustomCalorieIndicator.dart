import 'package:flutter/material.dart';
import 'dart:math';


class CircularCalorieIndicator extends StatelessWidget {
  final int totalCalories;
  final double carbPercentage;
  final double fatPercentage;
  final double proteinPercentage;
  final double fiberPercentage;

  const CircularCalorieIndicator({
    Key? key,
    required this.totalCalories,
    required this.carbPercentage,
    required this.fatPercentage,
    required this.proteinPercentage,
    required this.fiberPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: CustomPaint(
            painter: MultiSegmentPainter(
              carbPercentage: carbPercentage,
              fatPercentage: fatPercentage,
              proteinPercentage: proteinPercentage,
              fiberPercentage: fiberPercentage,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$totalCalories',
              style: Theme.of(context).textTheme.bodyLarge!.apply(fontWeightDelta: 2)
            ),
            Text(
              'cal',
              style:  Theme.of(context).textTheme.bodyLarge
            ),
          ],
        ),
      ],
    );
  }
}

class MultiSegmentPainter extends CustomPainter {
  final double carbPercentage;
  final double fatPercentage;
  final double proteinPercentage;
  final double fiberPercentage;

  MultiSegmentPainter({
    required this.carbPercentage,
    required this.fatPercentage,
    required this.proteinPercentage,
    required this.fiberPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -pi / 2;

    final totalPercentage = carbPercentage + fatPercentage + proteinPercentage + fiberPercentage;

    // Colors for segments
    final carbPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final proteinPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final fatPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final fiberPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    // Calculate angles for each segment
    final carbAngle = 2 * pi * (carbPercentage / totalPercentage);
    final fatAngle = 2 * pi * (fatPercentage / totalPercentage);
    final proteinAngle = 2 * pi * (proteinPercentage / totalPercentage);
    final fiberAngle = 2 * pi * (fiberPercentage / totalPercentage);

    // Draw each segment
    canvas.drawArc(rect, startAngle, carbAngle, false, carbPaint);
    canvas.drawArc(rect, startAngle + carbAngle, fatAngle, false, fatPaint);
    canvas.drawArc(rect, startAngle + carbAngle + fatAngle, proteinAngle, false, proteinPaint);
    canvas.drawArc(rect, startAngle + carbAngle + fatAngle + proteinAngle, fiberAngle, false, fiberPaint);
  }

  @override
  bool shouldRepaint(covariant MultiSegmentPainter oldDelegate) {
    return oldDelegate.carbPercentage != carbPercentage ||
        oldDelegate.fatPercentage != fatPercentage ||
        oldDelegate.proteinPercentage != proteinPercentage ||
        oldDelegate.fiberPercentage != fiberPercentage;
  }

}