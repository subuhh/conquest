class RecipeModel {
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final double calories;
  final String recipeTime;
  final NutritionValue nutritionValue;
  final String imageUrl;
  final List<String> dietPreference;
  final String mealType;

  RecipeModel({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.calories,
    required this.recipeTime,
    required this.nutritionValue,
    required this.imageUrl,
    required this.dietPreference,
    required this.mealType,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'calories': calories,
      'recipeTime': recipeTime,
      'nutritionValue': nutritionValue.toJson(),
      'imageUrl': imageUrl,
      'dietPreference': dietPreference,
      'mealType': mealType,
    };
  }

  // Convert from JSON (Firestore data)
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      title: json['title'],
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      steps: List<String>.from(json['steps']),
      calories: json['calories'],
      recipeTime: json['recipeTime'],
      nutritionValue: NutritionValue.fromJson(json['nutritionValue']),
      imageUrl: json['imageUrl'],
      dietPreference: List<String>.from(json['dietPreference']),
      mealType: json['mealType'],
    );
  }

  RecipeModel copyWith({
    String? imageUrl,
  }) {
    return RecipeModel(
      title: title,
      description: description,
      ingredients: ingredients,
      steps: steps,
      calories: calories,
      recipeTime: recipeTime,
      nutritionValue: nutritionValue,
      dietPreference: dietPreference,
      mealType: mealType,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class Ingredient {
  final String ingredient;
  final String quantity;

  Ingredient({required this.ingredient, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient,
      'quantity': quantity,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredient: json['ingredient'],
      quantity: json['quantity'],
    );
  }
}

class NutritionValue {
  final int servings;
  final String protein;
  final String carbohydrates;
  final String fat;
  final String fiber;

  NutritionValue({
    required this.servings,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
  });

  Map<String, dynamic> toJson() {
    return {
      'servings': servings,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
    };
  }

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      servings: json['servings'],
      protein: json['protein'],
      carbohydrates: json['carbohydrates'],
      fat: json['fat'],
      fiber: json['fiber'],
    );
  }
}
