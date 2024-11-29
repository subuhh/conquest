import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String id;
  final String name;
  final List<String> ingredients;
  final String prepTime;
  final String cuisine;
  final String course;
  final String diet;
  final int? servings;
  final List<String> instructions;
  final String? protein;
  final String? fat;
  final String? fiber;
  final String? carbs;
  final String? calories;
  final String imageUrl;

  RecipeModel({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.prepTime,
    required this.cuisine,
    required this.course,
    required this.diet,
    this.servings,
    required this.instructions,
    this.protein,
    this.fat,
    this.fiber,
    this.carbs,
    required this.imageUrl,
    this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'prepTime': prepTime,
      'cuisine': cuisine,
      'course': course,
      'diet': diet,
      'servings': servings,
      'instructions': instructions,
      'protein': protein,
      'fat': fat,
      'fiber': fiber,
      'carbs': carbs,
      'imageUrl': imageUrl,
      'calories': calories,
    };
  }

  factory RecipeModel.fromDocument(DocumentSnapshot doc) {
    return RecipeModel(
      id: doc['id'].toString(),
      name: doc['name'],
      ingredients: List<String>.from(doc['ingredients']),
      prepTime: doc['prepTime'],
      cuisine: doc['cuisine'],
      course: doc['course'],
      diet: doc['diet'],
      servings: doc['servings'],
      instructions: List<String>.from(doc['instructions']),
      protein: doc['protein'],
      fat: doc['fat'],
      fiber: doc['fiber'],
      carbs: doc['carbs'],
      imageUrl: doc['imageUrl'],
      calories: doc['calories'],
    );
  }
}
