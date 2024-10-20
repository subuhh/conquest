import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'RecomendedMeals/RecomendedMeals.dart';

class Mealplanspage extends StatelessWidget {
  const Mealplanspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //DaySelector(),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Recomendedmeals(MealTime: "for BreakFast",),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Recomendedmeals(MealTime: "for Morning Snax",),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Recomendedmeals(MealTime: "for Lunch",),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Recomendedmeals(MealTime: "for Evening Snack",),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Recomendedmeals(MealTime: "for Dinner",),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
