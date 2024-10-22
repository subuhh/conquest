import 'package:conquest/features/Nutrition/Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class WaterIntake extends StatelessWidget {
  final double currentWaterIntake;
  final double waterGoal;

  const WaterIntake({
    Key? key,
    required this.currentWaterIntake,
    required this.waterGoal,
  }) : super(key: key);

  double calculateProgress() {
    if (waterGoal > 0) {
      return currentWaterIntake / waterGoal;
    } else {
      return 0.0; // Default if goal is 0
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressWithCenterWidget(
                  progress: progress,
                  ProgressColor: Colors.blueAccent,
                  centerWidget: Icon(
                    Icons.local_drink,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Water Intake",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: TColors.darkGrey),
                ),
                SizedBox(height: TSizes.spaceBtwItems / 4),
                Text(
                  "${currentWaterIntake} / ${waterGoal.round()} L",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(color: TColors.black),
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blueAccent,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
