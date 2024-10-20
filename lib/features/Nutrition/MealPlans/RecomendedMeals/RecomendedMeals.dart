import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';

import 'Widgets/RecomendedMealCardWidget.dart';


class Recomendedmeals extends StatelessWidget {
  const Recomendedmeals({super.key,this.MealTime=""});

  final String MealTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recomended Meals ${MealTime}',style: Theme.of(context).textTheme.headlineSmall,textAlign: TextAlign.left,),
            Icon(Icons.keyboard_double_arrow_right)
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems,),
        Container(
          height: 200,
          width: double.maxFinite,
child: ListView(
  scrollDirection: Axis.horizontal,
  children: [
    RecomendedMealCardSmall(context, ),
    RecomendedMealCardSmall(context,),
    RecomendedMealCardSmall(context,),
  ],
),
        )
      ],
    );
  }
}



