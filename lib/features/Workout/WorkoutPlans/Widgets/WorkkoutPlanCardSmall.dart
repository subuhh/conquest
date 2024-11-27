import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../WorkoutTutorial/workout_plan_page.dart';
import '../MostPopularWorouts/MostPopulatWorkouts.dart';

class WorkoutPlanCardSmall extends StatelessWidget {
  final WorkoutDetail workout;

  const WorkoutPlanCardSmall({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Card(
      elevation: 1,
      color: TColors.primaryBackground,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => WorkoutPlanPage(workout: workout, wantButton: false));
        },
        child: Column(
          children: [
            SizedBox(
              width: s.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: Image.asset(
                      workout.imageUrl,
                      height: s.height * 0.2,
                      width: s.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${workout.level}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .apply(color: Colors.grey[700]),
                          textAlign: TextAlign.left,
                        ),
                      ],
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
