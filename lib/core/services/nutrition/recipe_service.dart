import 'dart:developer' as dev;
import 'dart:math';
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
      String userUid, String mealType, int offset, int limit) async {
    // Fetch user details using UID
    UserModel? user = await firestoreService.getUserDetails(userUid);

    // Handle if user data is unavailable
    if (user == null) {
      return [];
    }

    // Retrieve diet preferences and calorie goal
    List<String> diets = user.dietPreference!;
    final calorieGoal = user.calorieGoal;
    dev.log('User Diet Preferences: $diets');
    dev.log('User Calorie Goal for a Meal: $calorieGoal');

    // Map user diet preferences to recipe categories
    List<String> allowedRecipeDiets = [];
    for (var diet in diets) {
      if (dietMapping.containsKey(diet)) {
        allowedRecipeDiets.addAll(dietMapping[diet]!);
      }
    }
    dev.log('Allowed Recipe Diets: $allowedRecipeDiets');

    // Fetch previously recommended recipes for the user
    List<String> previouslyRecommendedRecipeIds =
        await getUserPreviouslyRecommendedRecipes(userUid);

    // Fetch recipes from Firestore
    final querySnapshot = await recipeCollection.get();

    // Convert query snapshot to RecipeModel list
    List<RecipeModel> allRecipes =
        querySnapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

    // Filter recipes by strict diet preferences and exclude previously recommended recipes
    List<RecipeModel> filteredByDiet = allRecipes.where((recipe) {
      // Adjusted to check if `recipe.diet` (as a String) matches all user's diet preferences
      bool matchesAllDiets = diets.every(
          (userDiet) => dietMapping[userDiet]?.contains(recipe.diet) ?? false);
      return matchesAllDiets &&
          !previouslyRecommendedRecipeIds.contains(recipe.id);
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
        dev.log(
            'Error parsing calories for recipe: ${recipe.id}, ${recipe.calories}');
        return false; // Exclude if parsing fails
      }
    }).toList();

    // Prioritize high-protein recipes
    List<RecipeModel> highProteinRecipes = filteredByCalorie
        .where((recipe) => recipe.diet.contains(diets[0] == 'Vegetarian'
            ? allowedRecipeDiets[1]
            : allowedRecipeDiets[2]))
        .toList();

    List<RecipeModel> nonHighProteinRecipes = filteredByCalorie
        .where((recipe) => !recipe.diet.contains(diets[0] == 'Vegetarian'
            ? allowedRecipeDiets[1]
            : allowedRecipeDiets[2]))
        .toList();

    // Combine the high-protein recipes with the non-high-protein recipes, and shuffle the list
    List<RecipeModel> recommendedRecipes = [
      ...highProteinRecipes,
      ...nonHighProteinRecipes
    ];
    recommendedRecipes.shuffle(Random());

    // Take the required number of recipes based on the offset and limit
    List<RecipeModel> paginatedRecipes =
        recommendedRecipes.skip(offset).take(limit).toList();

    // Store the recommended recipes for the user to avoid showing the same recipes again
    await storeUserRecommendedRecipes(userUid,
        paginatedRecipes.map((recipe) => recipe.id.toString()).toList());

    // dev.log the final recommended recipes
    dev.log('Recommended Recipes Count: ${paginatedRecipes.length}');
    return paginatedRecipes;
  }

  // Fetch previously recommended recipes for the user from Firestore
  Future<List<String>> getUserPreviouslyRecommendedRecipes(
      String userUid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    final previouslyRecommendedRecipes =
        userDoc.data()?['previouslyRecommendedRecipes'] as List<dynamic>?;
    return previouslyRecommendedRecipes?.map((id) => id.toString()).toList() ??
        [];
  }

  // Store the recommended recipes for the user in Firestore
  Future<void> storeUserRecommendedRecipes(
      String userUid, List<String> recommendedRecipeIds) async {
    await FirebaseFirestore.instance.collection('users').doc(userUid).update({
      'previouslyRecommendedRecipes':
          FieldValue.arrayUnion(recommendedRecipeIds),
    });
  }
}
