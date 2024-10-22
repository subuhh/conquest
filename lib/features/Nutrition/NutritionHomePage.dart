import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:conquest/features/Nutrition/DaySelector/DaySelector.dart';
import 'package:conquest/features/Nutrition/MealPlans/RecomendedMeals/RecomendedMeals.dart';
import 'package:conquest/features/Nutrition/WaterIntakeWidget/water_intake.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'DietTracker/DietTrackerWidget.dart';
import 'Widgets/NewMealFromScratch/NewMealFromScratch.dart';
import 'Widgets/WhatsInYourFridge/WhatsInYourFridge.dart';

class NutritionHomePage extends StatelessWidget {
  const NutritionHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(),
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
              SizedBox(height: TSizes.spaceBtwSections / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MealPlanContainerWidget(),
                  WhatsInYourFridge(),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwSections * 3),
            ],
          ),
        ),
      ),
    );
  }
}
