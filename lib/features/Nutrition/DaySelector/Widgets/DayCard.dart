import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/constants/colors.dart';

class DayCard extends StatelessWidget {
  final String day;
  final String date;
  final bool isActive;
  final bool isToday;
  final bool isSelected;
  final Function()? onTap;

  const DayCard({
    Key? key,
    required this.day,
    required this.date,
    required this.isActive,
    this.isToday = false,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the gradient colors based on the state (active, inactive, or today)
    Gradient backgroundGradient;
    Color textColor;
    Color iconColor;

    if (isSelected && !isToday) {
      // Gradient for selected day
      backgroundGradient = LinearGradient(
        colors: [TColors.primary, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.white;
      iconColor = Colors.blueAccent.withOpacity(0.7);
    } else if (isToday) {
      // Gradient for active days
      backgroundGradient = LinearGradient(
        colors: [
          TColors.primary,
          TColors.primary,
          Colors.white54,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.white;
      iconColor = TColors.primary.withOpacity(0.7);
    } else if (!isActive) {
      // Gradient for today
      backgroundGradient = LinearGradient(
        colors: [Colors.black, Colors.grey],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.white;
      iconColor = Colors.grey;
    } else {
      // Gradient for inactive days
      backgroundGradient = LinearGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade100],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.grey;
      iconColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: isToday || !isActive ? onTap : null,
      child: Container(
        width: 55, // Set a fixed width for each day card
        //padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: -10,
              child: Transform.rotate(
                angle: 6,
                child: SvgPicture.asset(
                  'assets/icons/nutrition/newMeal.svg',
                  height: 40,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  // color: iconColor,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: textColor),
                  ),
                  Text(
                    date,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(color: textColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
