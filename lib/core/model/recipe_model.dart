import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final double calories;
  final String recipeTime;
  final NutritionValue nutritionValue;
  final String imageUrl;
  final String dietPreference;
  final String mealType;
  final String hash;
  final FieldValue createdAt;

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
    required this.hash,
    required this.createdAt,
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
      'hash': hash,
      'createdAt': createdAt
    };
  }

  // Convert from JSON (Firestore data)
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    try {
      return RecipeModel(
        title: json['title'] as String,
        description: json['description'] as String,
        ingredients: (json['ingredients'] as List<dynamic>)
            .map((ingredientItem) => Ingredient.fromJson(ingredientItem as Map<String, dynamic>))
            .toList(),
        steps: List<String>.from(json['steps'] as List<dynamic>),
        calories: json['calories'] as double,
        recipeTime: json['recipeTime'] as String,
        nutritionValue: NutritionValue.fromJson(json['nutritionValue'] as Map<String, dynamic>),
        imageUrl: json['imageUrl'] as String,
        dietPreference: json['dietPreference'] as String,
        mealType: json['mealType'] as String,
        hash: json['hash'] as String,
        createdAt: json['createdAt'] as FieldValue,
      );
    } catch (e) {
      log('Error in RecipeModel.fromJson: $e');
      throw e;
    }
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
      hash: hash,
      createdAt: createdAt,
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
