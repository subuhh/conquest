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
      final fetchedRecipes = await _recipeService
          .getRecommendedRecipes(AuthService.instance.currentUser!.uid,'');
      recipes.assignAll(fetchedRecipes);
    } finally {
      isLoading(false);
    }
  }
}
