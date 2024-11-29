import 'dart:developer';

import 'package:get/get.dart';
import '../../model/Nutrition/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/nutrition/recipe_service.dart';
import '../user_controller.dart';

class RecipeController extends GetxController {
  static RecipeController instance = Get.find();

  var isLoading = false.obs;
  RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  RxList<RecipeModel> fetchedRecipesByIds = <RecipeModel>[].obs;

  final _recipeService = RecipeService();

  int offset = 0;
  final int limit = 3;

  @override
  void onInit() {
    super.onInit();
    log('Fetching recipe');
    fetchRecipes(); // Fetch recipes when the controller is initialized
  }

  // Fetch all recipes from Firestore
  Future<void> fetchRecipes() async {
    isLoading(true);
    try {
      final fetchedRecipes = await _recipeService.getRecommendedRecipes(
          AuthService.instance.currentUser!.uid, '', offset, limit);
      recipes.clear();
      recipes.addAll(fetchedRecipes);
      offset += limit;

      final userModel = UserController.instance.userModel.value;

      if (userModel != null) {
        await fetchRecipesByIds(userModel.previouslyGeneratedRecipes!);
      }
    } finally {
      isLoading(false);
    }
  }

  void reloadRecipes() {
    fetchRecipes();
  }

  // Fetch recipes by a list of IDs
  Future<void> fetchRecipesByIds(List<String> recipeIds) async {
    isLoading(true);
    try {
      final fetchedByIds = await _recipeService.getRecipesByIds(recipeIds);
      fetchedRecipesByIds.clear();
      fetchedRecipesByIds.addAll(fetchedByIds);
      log('Fetched ${fetchedByIds.length} recipes by IDs');
    } catch (e) {
      log('Error fetching recipes by IDs: $e');
    } finally {
      isLoading(false);
    }
  }

  // Store the recipe in Firestore after image generation
  Future<void> storeRecipeAfterImageGeneration(
      List<Map<String, dynamic>> recommendations,
      List<String> imageUrls) async {
    try {
      // Store each recipe in Firebase
      for (var recipe in recommendations) {
        // Process ingredients
        List<String> formattedIngredients = (recipe['ingredients'] as List)
            .map((ingredient) =>
                '${ingredient['quantity'].toString()} ${ingredient['ingredient']}')
            .toList();

        // Process instructions
        List<String> instructions = (recipe['steps'] as List)
            .map((step) => step['instruction'] as String)
            .toList();

        RecipeModel recipeModel = RecipeModel(
          id: '',
          name: recipe['title'],
          ingredients: formattedIngredients,
          prepTime: recipe['recipeTime'],
          cuisine: recipe['cuisine'],
          course: recipe['course'],
          diet: recipe['diet'],
          servings: recipe['nutritionValue']['servings'],
          instructions: instructions,
          protein: recipe['nutritionValue']['protein'],
          fat: recipe['nutritionValue']['fat'],
          fiber: recipe['nutritionValue']['fiber'],
          carbs: recipe['nutritionValue']['carbohydrates'],
          calories: recipe['calories'].toString(),
          imageUrl: imageUrls.isNotEmpty
              ? imageUrls[recommendations.indexOf(recipe)]
              : '', // Assign image URL
        );

        // Store the recipe in Firebase and get the generated ID
        String recipeId = await _recipeService.storeRecipe(recipeModel);

        String userId = UserController.instance.userModel.value!.id;

        // Update the user with the recipe ID
        await _recipeService.updateUserWithGeneratedRecipe(userId, recipeId);

        fetchedRecipesByIds.add(recipeModel);
      }
      log("Recipes and images stored successfully!");
    } catch (e) {
      log("Error storing recipe after image generation: $e");
    }
  }
}
