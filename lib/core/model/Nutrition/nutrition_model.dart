class WaterIntake {
  int totalWaterMl;
  List<int> entries; // Stores each water entry in ml

  WaterIntake({required this.totalWaterMl, required this.entries});

  Map<String, dynamic> toMap() {
    return {
      'totalWaterMl': totalWaterMl,
      'entries': entries,
    };
  }

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      totalWaterMl: map['totalWaterMl'],
      entries: List<int>.from(map['entries']),
    );
  }
}

class CalorieIntake {
  Meal breakfast;
  Meal morningSnack;
  Meal lunch;
  Meal eveningSnack;
  Meal dinner;

  CalorieIntake({
    required this.breakfast,
    required this.morningSnack,
    required this.lunch,
    required this.eveningSnack,
    required this.dinner,
  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast.toMap(),
      'morningsnack': morningSnack.toMap(),
      'lunch': lunch.toMap(),
      'eveningsnack': eveningSnack.toMap(),
      'dinner': dinner.toMap(),
    };
  }

  factory CalorieIntake.fromMap(Map<String, dynamic> map) {
    return CalorieIntake(
      breakfast: Meal.fromMap(map['breakfast']),
      morningSnack: Meal.fromMap(map['morningsnack']),
      lunch: Meal.fromMap(map['lunch']),
      eveningSnack: Meal.fromMap(map['eveningsnack']),
      dinner: Meal.fromMap(map['dinner']),
    );
  }
}

class Meal {
  List<String> items; // Example: ["roti", "dal", "salad"]
  int totalCalories;
  Map<String, double>
      macros; // Example: {'protein': 15.0, 'carbs': 45.0, 'fat': 12.0}

  Meal({
    required this.items,
    required this.totalCalories,
    required this.macros,
  });

  static Meal empty() {
    return Meal(
      items: [],
      totalCalories: 0,
      macros: {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'totalCalories': totalCalories,
      'macros': macros,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      items: List<String>.from(map['items']),
      totalCalories: map['totalCalories'],
      macros: Map<String, double>.from(map['macros']),
    );
  }
}
