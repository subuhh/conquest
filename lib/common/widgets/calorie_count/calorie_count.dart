class CalorieCalculator {
  static double calculateBMR({
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
  }) {
    if (gender.toLowerCase() == 'male') {
      return 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
    }
  }

  static double calculateTDEE(double bmr, String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'daily':
        return bmr * 1.9;
      case 'weekly':
        return bmr * 1.55;
      case 'rarely':
        return bmr * 1.2;
      case 'not regular':
        return bmr * 1.375;
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
}
