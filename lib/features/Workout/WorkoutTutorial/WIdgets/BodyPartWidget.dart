import 'package:flutter/material.dart';

import '../../../../core/model/Workout/workout_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';

class BodyPartWidget extends StatelessWidget {
  final WorkoutDetail? workout;
  final WorkoutDay? workoutDay;
  const BodyPartWidget({super.key, this.workout, this.workoutDay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Wrap VerticalDivider with Container and set width
              Container(
                width: 8, // Define width for the VerticalDivider
                child: VerticalDivider(
                  thickness: 3,
                  color: TColors.primary,
                ),
              ),
              SizedBox(width: 8), // Add space between divider and text
              Text(
                "Body Part",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(
            height: TSizes.spaceBtwItems / 1.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: TSizes.spaceBtwItems),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.6,
                // decoration: BoxDecoration(
                //   color: TColors.softGrey,
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      workout != null
                          ? workout!.exerciseName.toUpperCase()
                          : workoutDay!.target,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        imageUrl(workout != null ? workout!.exerciseName : ''),
                        fit: BoxFit.fill,
                        height: double.maxFinite,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

String imageUrl(String exerciseName) {
  if (exerciseName == 'chest')
    return 'assets/icons/Workout/chest.png';
  else if (exerciseName == 'leg')
    return 'assets/icons/Workout/leg.jpeg';
  else if (exerciseName == 'abs')
    return 'assets/icons/Workout/abs.jpeg';
  else if (exerciseName == 'cardio')
    return 'assets/icons/Workout/full_body.jpeg';
  else if (exerciseName == 'back')
    return 'assets/icons/Workout/abs.jpeg';
  else
    return 'assets/icons/Workout/full_body.jpeg';
}
