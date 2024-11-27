import 'package:conquest/core/Controllers/Workout_Controller/workout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/sizes.dart';
import '../workout_plan_page.dart';

class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    final workoutController = WorkoutController.instance;

    return GestureDetector(
      onTap: () {
        Get.to(() => WorkoutPlanPage(
            workoutDay: workoutController.currentDayWorkout.value));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          children: [
            // Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/icons/Workout/img.png',
                height: s.height * 0.25,
                width: s.width, // Full screen width
                fit: BoxFit.cover,
              ),
            ),
            // Black film overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            // Content
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 25,
                    width: 50,
                    child: Center(
                      child: Text(
                        '21/21',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 25,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Uncompleted',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Workout",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: Colors.white, fontWeightDelta: 2),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems / 2),
                  Obx(
                    () => Text(
                      "${workoutController.currentDayWorkoutPlan.value.planName}\n${workoutController.currentDayWorkout.value.totalTime} mins / ${workoutController.currentDayWorkout.value.totalCalories} kcal",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Action for Start button
                      },
                      child: const Text(
                        "Start Workout",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
