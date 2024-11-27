import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../Widgets/WorkkoutPlanCardSmall.dart';

class MostPopularWorkouts extends StatelessWidget {
  const MostPopularWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkoutDetail> workouts = [
      WorkoutDetail(
        imageUrl: 'assets/images/chest.jpeg',
        title: 'Intermediate Chest Building',
        time: '55 Mins',
        calorie: '300 - 350 kcal',
        level: 'Intermediate',
        exerciseName: 'chest',
      ),
      WorkoutDetail(
        imageUrl: 'assets/images/leg.jpeg',
        title: 'Beginners Leg Toning',
        time: '45 Mins',
        calorie: '250 - 300 kcal',
        level: 'Beginners',
        exerciseName: 'upper legs',
      ),
      WorkoutDetail(
        imageUrl: 'assets/images/shoulder.jpeg',
        title: 'Intermediate Shoulder Workout',
        time: '60 Mins',
        calorie: '355 - 400 kcal',
        level: 'Intermediate',
        exerciseName: 'shoulders',
      ),
      WorkoutDetail(
        imageUrl: 'assets/images/cardio.jpeg',
        title: 'Full Body Cardio',
        time: '50 Mins',
        calorie: '400 - 500 kcal',
        level: 'All Levels',
        exerciseName: 'cardio',
      ),
      WorkoutDetail(
        imageUrl: 'assets/icons/Workout/img.png',
        title: 'Strengthen Back Workout',
        time: '50 Mins',
        calorie: '250 - 350 kcal',
        level: 'Intermediate',
        exerciseName: 'back',
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " Top Workouts for Body Parts",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: TSizes.spaceBtwItems / 2),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1.35,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return WorkoutPlanCardSmall(workout: workouts[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class WorkoutDetail {
  final String imageUrl;
  final String title;
  final String time;
  final String calorie;
  final String level;
  final String exerciseName;

  WorkoutDetail({
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.calorie,
    required this.level,
    required this.exerciseName,
  });
}
