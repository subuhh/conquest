import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';
import 'DIetTrackerPage/DietTrackerPage.dart';

class DietTracker extends StatelessWidget {
  const DietTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;

    double calculateProgress(double consumed, double goal) {
      if (goal > 0) {
        return consumed / goal;
      } else {
        return 0.0; // Or any default value if goal is 0
      }
    }

    return GestureDetector(
      onTap: () => Get.to(() => DietTrackerPage()),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularProgressWithCenterWidget(
                  ProgressColor: Colors.deepOrangeAccent,
                  progress: 0.75, // Set the progress value
                  centerWidget: SvgPicture.asset(
                      'assets/icons/nutrition/fork-knife.svg',
                      height: 30,
                      width: 30),
                ),
                SizedBox(width: TSizes.spaceBtwItems),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "0 out of ${userController.userModel.value?.calorieGoal?.round()}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: TColors.darkGrey),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems / 4),
                    Text("Calorie consumed Today",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: TColors.black))
                  ],
                ),
                Spacer(),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepOrangeAccent,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            GridView(
              shrinkWrap:
                  true, // Makes sure the GridView doesn't expand infinitely
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                buildLinearProgressBar(context, "Protein", 15, 50),
                buildLinearProgressBar(context, "Fat", 20, 50),
                buildLinearProgressBar(context, "Carbohydrates", 10, 50),
                buildLinearProgressBar(context, "Fiber", 40, 50),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildLinearProgressBar(
      BuildContext context, String label, double consumed, double goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: TColors.darkGrey),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: (consumed / goal),
          backgroundColor: Colors.grey[300],
          color: Colors.deepOrangeAccent,
          minHeight: 8,
        ),
        SizedBox(height: 5),
        Text(
          "${consumed.round()} / ${goal.round()}",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .apply(color: TColors.darkGrey),
        ),
      ],
    );
  }
}
