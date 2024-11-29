import 'dart:convert';
import 'dart:developer';
import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import 'package:conquest/core/services/nutrition/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/nutrition/chat_gpt_service.dart';

class FridgeAIRecipeGeneratorController extends GetxController {
  static FridgeAIRecipeGeneratorController get instance => Get.find();

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  var selectedIngredients = <String>[].obs;
  var maxCalories = 0.obs;
  var macros = <String, dynamic>{}.obs;
  var personalTouch = ''.obs;

  var isLoadingRecipes = false.obs;
  var isLoadingImages = false.obs;
  var imageUrls = <String>[].obs;
  List<Map<String, dynamic>> recommendations = [];

  final ChatGptRecipeService _chatGptRecipeService = ChatGptRecipeService();
  final recipeService = RecipeService();
  final recipeController = RecipeController.instance;

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
      final response = await _chatGptRecipeService.fetchRecipeFridgeAi(prompt);
      final responses =
          parseRecipeJson(response['choices'][0]['message']['content']);
      recommendations = List<Map<String, dynamic>>.from(responses['recipes']);
      log('Controller: $recommendations');

      // isLoadingRecipes.value = false;

      recipeController.storeRecipeAfterImageGeneration(
          recommendations, imageUrls);

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
        final imageUrl =
            await _chatGptRecipeService.generateRecipeImage(description);
        log('$description: $imageUrl');
        imageUrls.add(imageUrl);
      } catch (error) {
        log('Error generating image: $error');
        imageUrls.add(''); // Add an empty string to maintain list consistency
      }
    }

    recipeController.storeRecipeAfterImageGeneration(
        recommendations, imageUrls);

    isLoadingImages.value = false;
  }

  // Method to clear all recipe-related data and reset state
  void clearRecipeData() {
    selectedIngredients.clear();
    maxCalories.value = 0;
    macros.clear();
    personalTouch.value = '';
    recommendations.clear();
    imageUrls.clear();
    isLoadingRecipes.value = false;
    isLoadingImages.value = false;
  }
}
