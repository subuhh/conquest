import 'package:conquest/core/Controllers/Workout_Controller/workout_controller.dart';
import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:conquest/features/Workout/DaySelector/DaySelector.dart';
import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/Controllers/Workout_Controller/workout_exercise_db_controller.dart';
import '../../utils/constants/sizes.dart';
import 'WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';

class WorkoutHomePage extends StatelessWidget {
  const WorkoutHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExerciseController());
    Get.put(WorkoutController());

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(
        left: 0,
        right: 40,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: TSizes.spaceBtwSections / 2),
                DaySelector(),
                SizedBox(height: TSizes.spaceBtwSections / 2),
                // DailyProgressBarIndicator(),
                // TodayWorkoutCard(),
                // SizedBox(height: TSizes.spaceBtwSections / 2.5),
                // WorkoutPlan(),
                // SizedBox(height: TSizes.spaceBtwSections / 1.5),
                MostPopularWorkouts(),
                SizedBox(height: TSizes.spaceBtwSections * 3.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
