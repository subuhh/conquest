import 'package:flutter/material.dart';

import '../CustomCalorieIndicator/CustomCalorieIndicator.dart';

class Mealnutritionindicatorwidget extends StatelessWidget {
  const Mealnutritionindicatorwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularCalorieIndicator(totalCalories: 400, carbPercentage: 60, fatPercentage: 10, proteinPercentage: 30),

        Column(
          children: [
            Text("60%",style: Theme.of(context).textTheme.bodyMedium!.apply(color:Colors.teal ),),
            Text("37.7g",style: Theme.of(context).textTheme.bodyLarge!.apply(fontWeightDelta: 2 ),),
            Text("Carbs",style: Theme.of(context).textTheme.bodyMedium!.apply(),),
          ],
        ),
        Column(
          children: [
            Text("10%",style: Theme.of(context).textTheme.bodyMedium!.apply(color:Colors.teal ),),
            Text("37.7g",style: Theme.of(context).textTheme.bodyLarge!.apply(fontWeightDelta: 2 ),),
            Text("Fats",style: Theme.of(context).textTheme.bodyMedium!.apply(),),
          ],
        ),
        Column(
          children: [
            Text("30%",style: Theme.of(context).textTheme.bodyMedium!.apply(color:Colors.teal ),),
            Text("37.7g",style: Theme.of(context).textTheme.bodyLarge!.apply(fontWeightDelta: 2 ),),
            Text("Protein",style: Theme.of(context).textTheme.bodyMedium!.apply(),),
          ],
        ),

      ],
    );
  }
}
