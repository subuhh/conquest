import 'dart:developer';

import 'package:get/get.dart';
import '../../model/Nutrition/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/nutrition/recipe_service.dart';

class RecipeController extends GetxController {
  static RecipeController instance = Get.find();

  var isLoading = false.obs;
  RxList<RecipeModel> recipes = <RecipeModel>[].obs;

  final _recipeService = FirebaseRecipeService();

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
      recipes.addAll(fetchedRecipes);
      offset += limit;
    } finally {
      isLoading(false);
    }
  }

  void reloadRecipes() {
    fetchRecipes();
  }
}
