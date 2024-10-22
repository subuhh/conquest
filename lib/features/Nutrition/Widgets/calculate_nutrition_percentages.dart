Map<String, double> calculateNutritionPercentages(
    double carbs, double protein, double fat, double fiber, double totalCalories) {

  // Convert macronutrient values to calories
  final double carbsCalories = carbs * 4;
  final double proteinCalories = protein * 4;
  final double fatCalories = fat * 9;
  final double fiberCalories = fiber * 2;  // Estimate fiber calories

  // Total calories from macronutrients
  final double calculatedTotalCalories = carbsCalories + proteinCalories + fatCalories + fiberCalories;

  // If totalCalories is provided and greater than calculated total, use it; otherwise, use the calculated one
  final double actualTotalCalories = totalCalories > 0 ? totalCalories : calculatedTotalCalories;

  // Calculate percentages
  final double carbPercentage = (carbsCalories / actualTotalCalories) * 100;
  final double proteinPercentage = (proteinCalories / actualTotalCalories) * 100;
  final double fatPercentage = (fatCalories / actualTotalCalories) * 100;
  final double fiberPercentage = (fiberCalories / actualTotalCalories) * 100;

  return {
    'carbPercentage': carbPercentage,
    'proteinPercentage': proteinPercentage,
    'fatPercentage': fatPercentage,
    'fiberPercentage': fiberPercentage,
  };
}
