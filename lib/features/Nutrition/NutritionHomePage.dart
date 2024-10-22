import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:conquest/features/Nutrition/DaySelector/DaySelector.dart';
import 'package:conquest/features/Nutrition/MealPlans/RecomendedMeals/RecomendedMeals.dart';
import 'package:conquest/features/Nutrition/WaterIntakeWidget/water_intake.dart';
import 'package:conquest/features/Nutrition/WhatsInYourFridge/WhatsInYourFridgePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/Controllers/Nutrition_Controller/recipe_favourite_controller.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'DietTracker/DietTrackerWidget.dart';

class NutritionHomePage extends StatelessWidget {
  const NutritionHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    Get.put(RecipeFavoriteController());

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => WhatsInYourFridgePage());
            },
            child: SvgPicture.asset(
              'assets/icons/nutrition/fridge-2.svg',
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwSections / 2,
          horizontal: TSizes.spaceBtwItems,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DaySelector(),
              SizedBox(height: TSizes.spaceBtwSections / 1.5),
              WaterIntake(currentWaterIntake: 1.5, waterGoal: 7.0),
              SizedBox(height: TSizes.spaceBtwSections / 1.5),
              DietTracker(),
              SizedBox(height: TSizes.spaceBtwSections / 2),
              RecommendedMeals(),
              // DailyRecommendedMeal(),
              // SizedBox(height: TSizes.spaceBtwSections / 2),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     MealPlanContainerWidget(),
              //     WhatsInYourFridge(),
              //   ],
              // ),
              // WhatsInYourFridge(),
              SizedBox(height: TSizes.spaceBtwSections * 4),
            ],
          ),
        ),
      ),
    );
  }
}
