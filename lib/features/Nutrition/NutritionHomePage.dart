import 'package:conquest/features/Nutrition/DailyRecomendedMeal/DailyRecommendedMeal.dart';
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
      appBar: AppBar(
        title: Text('Nutrition'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections,
            horizontal: TSizes.spaceBtwItems),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DietTracker(),
              SizedBox(height: TSizes.spaceBtwSections),
              DailyRecommendedMeal(),
              SizedBox(height: TSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NewMealFromScratch(),
                  WhatsInYourFridge(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
