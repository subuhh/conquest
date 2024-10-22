import 'package:flutter/material.dart';

import '../../../../core/Controllers/user_controller.dart';
import '../CustomCalorieIndicator/CustomCalorieIndicator.dart';

class MealNutritionIndicatorWidget extends StatelessWidget {
  const MealNutritionIndicatorWidget({super.key, required this.recipe});

  final Map<String, dynamic> recipe;

  // Function to calculate the nutrition percentage
  Map<String, double> calculateNutritionPercentage(
      double totalCalories, Map<String, dynamic> nutrition) {
    // Convert string values to double after removing 'g'
    double protein = double.parse(
        nutrition['protein'].toString().replaceAll('g', '').trim());
    double fat =
        double.parse(nutrition['fat'].toString().replaceAll('g', '').trim());
    double carbohydrates = double.parse(
        nutrition['carbohydrates'].toString().replaceAll('g', '').trim());
    double fiber =
        double.parse(nutrition['fiber'].toString().replaceAll('g', '').trim());

    double proteinCalories = protein * 4; // Protein has 4 calories per gram
    double fatCalories = fat * 9; // Fat has 9 calories per gram
    double carbCalories = carbohydrates * 4; // Carbs have 4 calories per gram
    double fiberCalories = fiber *
        2; // Fiber has roughly 2 calories per gram (not always counted, but for simplicity)

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
    final userController = UserController.instance;
    final nutrition = recipe['nutritionValue'];

    // Get the total calorie goal
    double totalCalories =
        userController.userModel.value!.calorieGoal!.round().toDouble();

    // Calculate nutrition percentages
    Map<String, double> nutritionPercentages =
        calculateNutritionPercentage(totalCalories, nutrition);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularCalorieIndicator(
          totalCalories: totalCalories.toInt(),
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
              "${nutrition['protein']}",
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
              "${nutrition['fat']}", // Keep this as a string
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
              "${nutrition['carbohydrates']}", // Keep this as a string
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
              "${nutrition['fiber']}", // Keep this as a string
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
