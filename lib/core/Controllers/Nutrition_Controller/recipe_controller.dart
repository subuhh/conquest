import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/recipe_model.dart';
import '../../services/recipe_service.dart';

class RecipeController extends GetxController {
  static RecipeController instance = Get.find();

  var isLoading = false.obs;
  RxList<RecipeModel> recipes = <RecipeModel>[].obs;

  final _recipeService = FirebaseRecipeService();

  Future<XFile> downloadImageAsXFile(String imageUrl) async {
    try {
      // Get the image bytes from the URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png';

        // Write the bytes to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Return an XFile
        return XFile(filePath);
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      log('Error downloading image: $e');
      throw e;
    }
  }

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
