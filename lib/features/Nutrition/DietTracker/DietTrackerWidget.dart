import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import '../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';
import 'DIetTrackerPage/DietTrackerPage.dart';

class DietTracker extends StatelessWidget {
  const DietTracker({super.key});

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
      if (nutritionController.isLoading.value) {
        return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
        );
      }

      final totalCalorie = userController!.calorieGoal!;
      final consumedCalorie = nutritionController.totalCalories.value;

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
                    progress: calculateProgress(consumedCalorie,
                        totalCalorie), // Set the progress value
                    centerWidget: SvgPicture.asset(
                      'assets/icons/nutrition/fork-knife.svg',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(width: TSizes.spaceBtwItems),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$consumedCalorie out of ${totalCalorie.ceil()}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .apply(color: TColors.darkGrey),
                      ),
                      SizedBox(height: TSizes.spaceBtwItems / 4),
                      Text(
                        "Calorie consumed Today",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: TColors.black),
                      )
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
              buildLinearProgressBar(
                context,
                "Protein",
                nutritionController.totalMacros["protein"]!.value,
                userController.proteinGoal!,
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  buildLinearProgressBar(
                    context,
                    "Fat",
                    nutritionController.totalMacros["fat"]!.value,
                    userController.fatGoal!,
                  ),
                  buildLinearProgressBar(
                    context,
                    "Carbohydrates",
                    nutritionController.totalMacros["carbs"]!.value,
                    userController.carbsGoal!,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
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
