import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class MacroNutrientsBreakdownWidget extends StatelessWidget {
  const MacroNutrientsBreakdownWidget({super.key});

  @override

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calories",style: textTheme.bodySmall!.apply(color: Colors.grey),textAlign: TextAlign.left,),
                    Text("85 cal",style: textTheme.headlineMedium,),
                  ],
                ),
                Text("Net Weight 35g",style: textTheme.bodyMedium,),
              ],

            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(),
          ),
          //SizedBox(height: TSizes.spaceBtwItems,),
          _buildNutritionRow('Protein', '10 gm', textTheme),
          _buildNutritionRow('Carbs', '30 gm', textTheme),
          _buildNutritionRow('Fats', '5 gm', textTheme),
          _buildNutritionRow('Fibre', '4 gm', textTheme),
          SizedBox(height: TSizes.spaceBtwItems,)

        ],
      ),
    );
  }
}


Widget _buildNutritionRow(String label, String value, TextTheme textTheme) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 8),
            Text(label, style: textTheme.bodyMedium),
          ],
        ),
        Text(value, style: textTheme.bodyMedium),
      ],
    ),
  );
}
