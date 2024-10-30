import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:conquest/features/Wokrout/DaySelector/DaySelector.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
import 'ProgressBarIndicator/ProgressBarIndicator.dart';
import 'WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';
import 'WorkoutPlans/WorkoutPlan.dart';


class Workouthomepage extends StatelessWidget {
  const Workouthomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: TSizes.spaceBtwSections),
                DaySelector(),
                DailyProgressBarIndicator(),
                Workoutplan(),
                SizedBox(height: TSizes.spaceBtwSections),

                Mostpopulatworkouts(),
                SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(height: TSizes.spaceBtwSections/2),
                //Trackers()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
