import 'package:flutter/material.dart';

import '../../../../../core/model/Nutrition/common_food_model.dart';
import '../../../../../utils/constants/sizes.dart';

class MacroNutrientsBreakdownWidget extends StatelessWidget {
  const MacroNutrientsBreakdownWidget({super.key, required this.item});

  final NutritionItem item;

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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calories",
                      style: textTheme.bodySmall!.apply(color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "${item.energyKcal.toInt()} cal",
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  "Net Weight: 100g",
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(),
          ),
          //SizedBox(height: TSizes.spaceBtwItems,),
          _buildNutritionRow('Protein', '${item.proteinG}g', textTheme),
          _buildNutritionRow('Carbs', '${item.carbG}g', textTheme),
          _buildNutritionRow('Fats', '${item.fatG}g', textTheme),
          _buildNutritionRow('Fibre', '${item.fibreG}g', textTheme),
          SizedBox(
            height: TSizes.spaceBtwItems,
          )
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
