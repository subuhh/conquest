import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import '../../../../../core/Controllers/user_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';

class TrackedDietWidget extends StatelessWidget {
  const TrackedDietWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance.userModel.value;
    final nutritionController = NutritionController.instance;

    double calculateProgress(double consumed, double goal) {
      if (goal > 0) {
        return consumed / goal;
      } else {
        return 0.0; // Or any default value if goal is 0
      }
    }

    return Obx(() {
      final totalCalorie = userController!.calorieGoal;
      final consumedCalorie = nutritionController.totalCalories.value;

      return Card(
        color: Colors.white,
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                child: CircularProgressWithCenterWidget(
                  ProgressColor: Colors.deepOrangeAccent,
                  progress: calculateProgress(consumedCalorie, totalCalorie!),
                  centerWidget: SvgPicture.asset(
                    'assets/icons/nutrition/fork-knife.svg',
                    height: 35,
                  ),
                ),
              ),
              //SizedBox(width: TSizes.spaceBtwItems,),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$consumedCalorie out of ${totalCalorie.ceil()}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: TColors.darkGrey),
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems / 4,
                  ),
                  Text(
                    "Calories Eaten",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(color: TColors.black),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
