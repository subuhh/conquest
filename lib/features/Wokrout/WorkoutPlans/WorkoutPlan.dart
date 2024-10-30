import 'package:flutter/material.dart';


import '../../../utils/constants/sizes.dart';
import 'Widgets/WorkoutPlanCardLarge.dart';

class Workoutplan extends StatelessWidget {
  const Workoutplan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Today's Workout Plan",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        SizedBox(
          height: 305,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,  // Set scroll direction to horizontal
            itemCount: 5,  // Number of items in the list
            itemBuilder: (context, index) {
              return WorkkoutPlanCardLarge();
            },
          ),
        ),
      ],
    );
  }
}
