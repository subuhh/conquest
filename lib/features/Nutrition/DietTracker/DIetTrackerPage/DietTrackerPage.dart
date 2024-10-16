import 'package:conquest/features/Nutrition/DietTracker/DIetTrackerPage/widgets/TrackedDietWidget.dart';
import 'package:conquest/features/Nutrition/DietTracker/DIetTrackerPage/widgets/TrackingMealCard/TrackingMealListCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class DietTrackerPage extends StatelessWidget {
  const DietTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.keyboard_arrow_left)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          child: Column(
            children: [
          TrackedDietWidget(),
              SizedBox(height: TSizes.spaceBtwSections,),
              TrackingMealListCard(mealTiming: "BreakFast",),
              SizedBox(height: TSizes.spaceBtwItems,),
              TrackingMealListCard(mealTiming: "Morning Snack",),
              SizedBox(height: TSizes.spaceBtwItems,),
              TrackingMealListCard(mealTiming: "Lunch",),
              SizedBox(height: TSizes.spaceBtwItems,),
              TrackingMealListCard(mealTiming: "Evening Snack",),
              SizedBox(height: TSizes.spaceBtwItems,),
              TrackingMealListCard(mealTiming: "Dinner",),
            ],
          ),
        ),
      ),
    );
  }
}
