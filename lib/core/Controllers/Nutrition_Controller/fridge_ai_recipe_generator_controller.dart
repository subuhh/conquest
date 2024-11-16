import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import '../../services/nutrition/chat_gpt_service.dart';

class FridgeAIRecipeGeneratorController extends GetxController {
  static FridgeAIRecipeGeneratorController get instance => Get.find();

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  final recipeController = Get.put(RecipeController());

  var selectedIngredients = <String>[].obs;
  var maxCalories = 0.obs;
  var macros = <String, dynamic>{}.obs;
  var personalTouch = ''.obs;

  var isLoadingRecipes = false.obs;
  var isLoadingImages = false.obs;
  var imageUrls = <String>[].obs;
  List<Map<String, dynamic>> recommendations = [];

  final ChatGptRecipeService _recipeService = ChatGptRecipeService();

  Map<String, dynamic> parseRecipeJson(String recipe) {
    return jsonDecode(recipe);
  }

  Future<void> fetchChatGPTRecipe() async {
    isLoadingRecipes.value = true;

    final prompt = """
    Generate 2 healthy recipes based on the following inputs:
    Ingredients: ${selectedIngredients.join(", ")}
    ${maxCalories > 0 ? "Maximum Calories: $maxCalories" : ""}
    ${macros.isNotEmpty ? "Macros: ${macros.toString()}" : ""}
    ${personalTouch.isNotEmpty ? '$personalTouch' : ''}
    and choose recipe which has less number of ingredients
    """;

    try {
      final response = await _recipeService.fetchRecipeFridgeAi(prompt);
      final responses =
          parseRecipeJson(response['choices'][0]['message']['content']);
      recommendations = List<Map<String, dynamic>>.from(responses['recipes']);
      log('Controller: $recommendations');

      // Start generating images
      // await generateRecipeImages();
    } catch (error) {
      log('Error: $error');
    } finally {
      isLoadingRecipes.value = false;
    }
  }

  // Generate images for recipes
  Future<void> generateRecipeImages() async {
    log('Image started to generate');
    isLoadingImages.value = true;
    imageUrls.clear(); // Clear previous image URLs

    for (var recipe in recommendations) {
      final description = recipe['description'];
      log('Image description: $description');
      try {
        // Generate the image URL based on recipe description
        final imageUrl = await _recipeService.generateRecipeImage(description);
        log('$description: $imageUrl');
        imageUrls.add(imageUrl);
      } catch (error) {
        log('Error generating image: $error');
        imageUrls.add(''); // Add an empty string to maintain list consistency
      }
    }

    isLoadingImages.value = false;
  }
}

// String _generateRecipeHash(Map<String, dynamic> recipe) {
//   final title = recipe['title'];
//   final data = '$title';
//   return sha256.convert(utf8.encode(data)).toString();
// }

// Future<bool> _isRecipeInDatabase(String hash) async {
//   final querySnapshot = await FirebaseFirestore.instance
//       .collection('recipes')
//       .where('hash', isEqualTo: hash)
//       .get();
//   return querySnapshot.docs.isNotEmpty;
// }

// Future<void> _saveRecipeToFirebase(
//     Map<String, dynamic> recipe, String imageUrl, String hash) async {
//   try {
//     final recipeModel = {
//       'title': recipe['title'],
//       'description': recipe['description'],
//       'ingredients': recipe['ingredients'],
//       'steps': recipe['steps'],
//       'calories': recipe['calories'],
//       'recipeTime': recipe['recipeTime'],
//       'nutritionValue': recipe['nutritionValue'],
//       'imageUrl': imageUrl,
//       'dietPreference': selectedDiet.value,
//       'mealType': mealType.value,
//       'hash': hash,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//
//     await FirebaseFirestore.instance.collection('recipes').add(recipeModel);
//     log('Recipe saved: ${recipe['title']}');
//   } catch (e) {
//     log('Error saving recipe: $e');
//   }
// }
