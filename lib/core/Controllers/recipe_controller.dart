import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeController extends GetxController {
  static RecipeController instance = Get.find();

  var isLoading = false.obs;
  RxList<RecipeModel> recipes = <RecipeModel>[].obs;

  final _recipeService = FirebaseRecipeService();

  // Fetch all recipes from Firestore
  Future<void> fetchRecipes() async {
    isLoading(true);
    try {
      final fetchedRecipes = await _recipeService.getAllRecipes();
      recipes.assignAll(fetchedRecipes);
    } finally {
      isLoading(false);
    }
  }

  // Save recipe to Firestore and upload image to Firebase Storage
  Future<void> saveRecipe(RecipeModel recipe, XFile imageFile) async {
    isLoading(true);
    try {
      final imageUrl = await _recipeService.uploadRecipeImage(imageFile);
      final newRecipe = recipe.copyWith(imageUrl: imageUrl);
      await _recipeService.addRecipe(newRecipe);
      recipes.add(newRecipe);
    } finally {
      isLoading(false);
    }
  }
}
