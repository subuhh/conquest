import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Nutrition/recipe_model.dart';
import '../../model/user.dart';
import '../firestore_service.dart';

class FirebaseRecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('Recipes');
  final firestoreService = FirestoreService();

  // Map user diet preferences to recipe categories
  final Map<String, List<String>> dietMapping = {
    'Vegetarian': ['Vegetarian', 'High Protein Vegetarian'],
    'Vegan': ['Vegan'],
    'Non-veg': ['Non Vegetarian', 'Eggetarian', 'High Protein Non Vegetarian'],
    'Dairy-Free': ['Vegan', 'Diabetic Friendly'],
    'Keto': ['Keto'],
    'Gluten-Free': ['Gluten Free'],
  };

  // Fetch recipes from Firestore based on user preferences
  Future<List<RecipeModel>> getRecommendedRecipes(
      String userUid, String mealType) async {
    // Fetch user details using UID
    UserModel? user = await firestoreService.getUserDetails(userUid);

    // Handle if user data is unavailable
    if (user == null) {
      return [];
    }

    // Retrieve diet preferences and calorie goal
    List<String> diets = user.dietPreference!;
    final calorieGoal = user.calorieGoal;
    log('User Diet Preferences: $diets');
    log('User Calorie Goal for a Meal: $calorieGoal');

    // Map user diet preferences to recipe categories
    List<String> allowedRecipeDiets = [];
    for (var diet in diets) {
      if (dietMapping.containsKey(diet)) {
        allowedRecipeDiets.addAll(dietMapping[diet]!);
      }
    }
    log('Allowed Recipe Diets: $allowedRecipeDiets');

    // Fetch recipes from Firestore with filtering by meal type
    final querySnapshot = await recipeCollection
        // .where('protein', isGreaterThan: 0)
        .get();

    // Convert query snapshot to RecipeModel list
    List<RecipeModel> allRecipes =
        querySnapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

    // Filter recipes by strict diet preferences
    List<RecipeModel> filteredByDiet = allRecipes.where((recipe) {
      // Adjusted to check if `recipe.diet` (as a String) matches any allowed diet preference
      return allowedRecipeDiets.contains(recipe.diet);
    }).toList();

    // Further filter recipes based on calorie goal
    List<RecipeModel> filteredByCalorie = filteredByDiet.where((recipe) {
      // Ensure calories is not null and can be parsed to an integer
      if (recipe.calories == null || recipe.calories!.isEmpty) {
        return false; // Exclude recipes without calorie information
      }
      try {
        int recipeCalories = int.parse(recipe.calories.toString());
        return recipeCalories <= calorieGoal!;
      } catch (e) {
        log('Error parsing calories for recipe: ${recipe.id}, ${recipe.calories}');
        return false; // Exclude if parsing fails
      }
    }).toList();

    // Sort the recommended recipes by calorie content
    filteredByCalorie.sort((a, b) => a.calories!.compareTo(b.calories!));

    // Log the final recommended recipes
    log('Recommended Recipes Count: ${filteredByCalorie.length}');
    return filteredByCalorie;
  }
}
