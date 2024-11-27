import 'package:conquest/core/model/Workout/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';

class WorkoutImageWithDetails extends StatelessWidget {
  final WorkoutDetail? workout;
  final WorkoutDay? workoutDay;
  const WorkoutImageWithDetails({super.key, this.workout, this.workoutDay});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Image.asset(
            workout != null
                ? workout!.imageUrl
                : 'assets/icons/Workout/img.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 15,
          left: 10,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 25, // Adjusted for better visibility
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50), // Adds some top padding
              child: Center(
                child: Text(
                  'Workout Details',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom:
              40, // Adjusted position to ensure it's above the orange container
          left: 30,
          right: 30,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Workout/stopwatch.png',
                      height: 20,
                    ),
                    Text(
                      workout != null
                          ? workout!.time
                          : '${workoutDay!.totalTime}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: Colors.white),
                    ),
                    Text(
                      "mins",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.grey),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: VerticalDivider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Workout/fire.png',
                      height: 20,
                    ),
                    Text(
                      workout != null
                          ? workout!.calorie
                          : '${workoutDay!.totalCalories}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: Colors.white),
                    ),
                    Text(
                      "Cal",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.grey),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: VerticalDivider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Workout/WaterDrops.png',
                      height: 20,
                    ),
                    Text(
                      "L1",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: Colors.white),
                    ),
                    Text(
                      workout != null ? workout!.level : 'Intermediate',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
