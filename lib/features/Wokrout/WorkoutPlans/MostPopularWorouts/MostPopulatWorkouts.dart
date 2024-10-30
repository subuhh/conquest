import 'package:flutter/material.dart';


import '../../../../utils/constants/sizes.dart';
import '../Widgets/WorkkoutPlanCardSmall.dart';

class Mostpopulatworkouts extends StatelessWidget {
  const Mostpopulatworkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Most Popular Workouts", style: Theme.of(context).textTheme.titleLarge,textAlign: TextAlign.left,),
        SizedBox(height: TSizes.spaceBtwItems/2,),
    SizedBox(
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,  // Set scroll direction to horizontal
        itemCount: 5,  // Number of items in the list
        itemBuilder: (context, index) {
          return Workkoutplancardsmall();
        },
      ),
    )
      ],
    );
  }
}
