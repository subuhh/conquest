class CalorieCalculator {
  static double calculateBMR({
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
  }) {
    if (gender.toLowerCase() == 'male') {
      return 66.47 + (13.75 * weightKg) + (5.003 * heightCm) - (6.755 * age);
    } else {
      return 655.1 + (9.563 * weightKg) + (1.850 * heightCm) - (4.676 * age);
    }
  }

  static double calculateTDEE(double bmr, String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'daily':
        return bmr * 1.9;
      case 'weekly':
        return bmr * 1.725;
      case 'occasionally':
        return bmr * 1.55;
      case 'rarely':
        return bmr * 1.375;
      case 'sedentary':
        return bmr * 1.2;
      default:
        return bmr * 1.2;
    }
  }

  static double calculateCalorieAdjustment(List<String> goals) {
    double adjustment = 0;
    if (goals.contains('lose weight')) {
      adjustment -= 500;
    }
    if (goals.contains('gain muscles')) {
      adjustment += 300;
    }
    if (goals.contains('build strength')) {
      adjustment += 200;
    }
    return adjustment;
  }

  static double calculateCalorieRequirement({
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String activityLevel,
    required List<String> goals,
  }) {
    double bmr = calculateBMR(
        age: age, gender: gender, heightCm: heightCm, weightKg: weightKg);
    double tdee = calculateTDEE(bmr, activityLevel);
    double adjustment = calculateCalorieAdjustment(goals);
    return tdee + adjustment;
  }

  // Macronutrient Calculation Based on Goals
  static Map<String, double> calculateMacros(
      double totalCalories, String goal) {
    // Default Ratios
    double proteinRatio;
    double fatRatio;
    double carbsRatio;

    switch (goal.toLowerCase()) {
      case 'lose weight':
        // Higher protein to preserve muscle, lower carbs
        proteinRatio = 0.35;
        fatRatio = 0.30;
        carbsRatio = 0.35;
        break;

      case 'gain muscles':
        // Balanced macros with emphasis on protein and carbs
        proteinRatio = 0.30;
        fatRatio = 0.25;
        carbsRatio = 0.45;
        break;

      case 'build strength':
        // Moderate protein, balanced carbs and fats
        proteinRatio = 0.25;
        fatRatio = 0.25;
        carbsRatio = 0.50;
        break;

      default:
        // Balanced as a fallback
        proteinRatio = 0.25;
        fatRatio = 0.25;
        carbsRatio = 0.50;
        break;
    }

    // Calculate macronutrient grams
    double proteinGrams = (totalCalories * proteinRatio) / 4; // 4 kcal per gram
    double fatGrams = (totalCalories * fatRatio) / 9; // 9 kcal per gram
    double carbsGrams = (totalCalories * carbsRatio) / 4; // 4 kcal per gram

    // Fiber: Default to 25-30g per day
    double fiberGrams = 30;

    return {
      'protein': proteinGrams,
      'carbs': carbsGrams,
      'fat': fatGrams,
      'fiber': fiberGrams,
    };
  }
}
