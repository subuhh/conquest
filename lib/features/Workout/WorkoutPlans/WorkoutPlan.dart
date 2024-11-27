import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import 'Widgets/WorkoutPlanCardLarge.dart';

class WorkoutPlan extends StatelessWidget {
  const WorkoutPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Other Workout Plan",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          height: 305,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return WorkoutPlanCardLarge();
            },
          ),
        ),
      ],
    );
  }
}
