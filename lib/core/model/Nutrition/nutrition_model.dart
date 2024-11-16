import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionModel {
  String userId;
  DateTime date;
  WaterIntake water;
  CalorieIntake calories;

  NutritionModel({
    required this.userId,
    required this.date,
    required this.water,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'water': water.toMap(),
      'calories': calories.toMap(),
    };
  }

  factory NutritionModel.fromMap(Map<String, dynamic> map) {
    return NutritionModel(
      userId: map['userId'],
      date: (map['date'] as Timestamp).toDate(),
      water: WaterIntake.fromMap(map['water']),
      calories: CalorieIntake.fromMap(map['calories']),
    );
  }
}

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
  Meal lunch;
  Meal snack;
  Meal dinner;

  CalorieIntake({
    required this.breakfast,
    required this.lunch,
    required this.snack,
    required this.dinner,
  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast.toMap(),
      'lunch': lunch.toMap(),
      'snack': snack.toMap(),
      'dinner': dinner.toMap(),
    };
  }

  factory CalorieIntake.fromMap(Map<String, dynamic> map) {
    return CalorieIntake(
      breakfast: Meal.fromMap(map['breakfast']),
      lunch: Meal.fromMap(map['lunch']),
      snack: Meal.fromMap(map['snack']),
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
