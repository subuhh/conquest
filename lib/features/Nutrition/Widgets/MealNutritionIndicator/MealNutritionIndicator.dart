import 'package:conquest/core/model/Nutrition/recipe_model.dart';
import 'package:flutter/material.dart';
import '../CustomCalorieIndicator/CustomCalorieIndicator.dart';

class MealNutritionIndicatorWidget extends StatelessWidget {
  const MealNutritionIndicatorWidget({super.key, required this.recipe});

  final RecipeModel recipe;

  // Function to calculate the nutrition percentage
  Map<String, double> calculateNutritionPercentage(
      double totalCalories, RecipeModel recipe) {
    // Parse nutrient values from the recipe model
    double protein = double.parse(recipe.protein!.replaceAll('g', '').trim());
    double fat = double.parse(recipe.fat!.replaceAll('g', '').trim());
    double carbohydrates =
        double.parse(recipe.carbs!.replaceAll('g', '').trim());
    double fiber = double.parse(recipe.fiber!.replaceAll('g', '').trim());

    double proteinCalories = protein * 4; // Protein has 4 calories per gram
    double fatCalories = fat * 9; // Fat has 9 calories per gram
    double carbCalories = carbohydrates * 4; // Carbs have 4 calories per gram
    double fiberCalories = fiber * 2; // Fiber has roughly 2 calories per gram

    double totalNutrientCalories =
        proteinCalories + fatCalories + carbCalories + fiberCalories;

    return {
      'protein': (proteinCalories / totalNutrientCalories) * 100,
      'fat': (fatCalories / totalNutrientCalories) * 100,
      'carbohydrates': (carbCalories / totalNutrientCalories) * 100,
      'fiber': (fiberCalories / totalNutrientCalories) * 100,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Get the total calorie goal
    double totalCalories = double.parse(recipe.calories!);

    // Calculate nutrition percentages
    Map<String, double> nutritionPercentages =
        calculateNutritionPercentage(totalCalories, recipe);

    print('Total Calories: $totalCalories');
    print('Carb Percentage: ${nutritionPercentages['carbohydrates']}');
    print('Fat Percentage: ${nutritionPercentages['fat']}');
    print('Protein Percentage: ${nutritionPercentages['protein']}');
    print('Fiber Percentage: ${nutritionPercentages['fiber']}');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularCalorieIndicator(
          totalCalories: int.parse(recipe.calories!),
          carbPercentage: nutritionPercentages['carbohydrates'] ?? 0,
          fatPercentage: nutritionPercentages['fat'] ?? 0,
          proteinPercentage: nutritionPercentages['protein'] ?? 0,
          fiberPercentage: nutritionPercentages['fiber'] ?? 0,
        ),
        Column(
          children: [
            Text(
              "${nutritionPercentages['protein']?.toStringAsFixed(1) ?? '0.0'}%",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.teal),
            ),
            Text(
              recipe.protein!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              "Protein",
              style: Theme.of(context).textTheme.bodyMedium!.apply(),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${nutritionPercentages['fat']?.toStringAsFixed(1) ?? '0.0'}%",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.teal),
            ),
            Text(
              recipe.fat!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              "Fats",
              style: Theme.of(context).textTheme.bodyMedium!.apply(),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${nutritionPercentages['carbohydrates']?.toStringAsFixed(1) ?? '0.0'}%",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.teal),
            ),
            Text(
              recipe.carbs!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              "Carbs",
              style: Theme.of(context).textTheme.bodyMedium!.apply(),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${nutritionPercentages['fiber']?.toStringAsFixed(1) ?? '0.0'}%",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.teal),
            ),
            Text(
              recipe.fiber!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              "Fiber",
              style: Theme.of(context).textTheme.bodyMedium!.apply(),
            ),
          ],
        ),
      ],
    );
  }
}
