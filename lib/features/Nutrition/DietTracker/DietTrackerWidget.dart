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

    // double calculateProgress() {
    //   final consumedCalories = userController.userModel.value?.calorie?.round() ?? 0;
    //   final calorieGoal = userController.userModel.value?.calorieGoal?.round() ?? 0;
    //   if (calorieGoal > 0) {
    //     return consumedCalories / calorieGoal;
    //   } else {
    //     return 0.0; // Or any default value if calorieGoal is 0
    //   }
    // }

    return GestureDetector(
      onTap: () => Get.to(() => DietTrackerPage()),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressWithCenterWidget(
              ProgressColor: Colors.deepOrangeAccent,
              progress: 0.75, // Set the progress value
              centerWidget: SvgPicture.asset(
                  'assets/icons/nutrition/fork-knife.svg',
                  height: 30,
                  width: 30),
              //   height: 35,)
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
                SizedBox(width: TSizes.spaceBtwItems / 4),
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
      ),
    );
  }
}
