class WaterIntakeCalCul {
  double calculateWaterIntakeGoal(double weight, String workoutFrequency) {
    double baseGoal = weight * 30; // 30ml per kg of body weight

    // Adjust based on workout frequency
    switch (workoutFrequency) {
      case 'Daily':
        baseGoal += 1000; // Add 1000 ml for daily workouts
        break;
      case 'Weekly':
        baseGoal += 500; // Add 500 ml for weekly workouts
        break;
      case 'Rarely':
        baseGoal += 200; // Add 200 ml for rare workouts
        break;
      case 'Not Regular':
        // No significant increase, keep the base goal
        break;
      default:
        // Handle unexpected cases if needed
        break;
    }

    return baseGoal; // Return the calculated goal in milliliters
  }
}
