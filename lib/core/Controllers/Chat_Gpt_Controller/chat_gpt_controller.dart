import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/chat_gpt_service.dart';
import '../user_controller.dart';

class RecipeRecommendationController extends GetxController {
  static RecipeRecommendationController get instance => Get.find();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  var selectedDiet = ''.obs;
  var mealType = ''.obs;
  var timeOfDay = ''.obs;
  var calories = 0.0.obs;
  var isLoadingRecipes = false.obs;
  var isLoadingImages = false.obs;
  List<Map<String, dynamic>> recommendations = [];
  var imageUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserData();
    _setMealType();
    fetchChatGPTRecipe();
  }

  void _initializeUserData() {
    final userController = UserController.instance;
    var diets = userController.userModel.value?.dietPreference ?? [];
    selectedDiet.value = diets.join(', ');
    calories.value = userController.userModel.value?.calorieGoal?.toDouble() ?? 500.0;
  }

  void _setMealType() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      mealType.value = 'Breakfast';
      timeOfDay.value = 'Morning';
    } else if (hour < 14) {
      mealType.value = 'Lunch';
      timeOfDay.value = 'Afternoon';
    } else if (hour < 18) {
      mealType.value = 'Snack';
      timeOfDay.value = 'Evening';
    } else {
      mealType.value = 'Dinner';
      timeOfDay.value = 'Night';
    }
  }

  final RecipeService _recipeService = RecipeService();

  Map<String, dynamic> parseRecipeJson(String recipe) {
    return jsonDecode(recipe);
  }

  Future<void> fetchChatGPTRecipe() async {
    isLoadingRecipes.value = true;

    final prompt = """
    Suggest only three Indian recipes in the format of json for a ${selectedDiet.value} 
    meal under ${calories.value.round()} calories, suitable for ${mealType.value}. Please 
    include the recipe title, a brief description, ingredients, steps, calorie, recipe time, 
    nutrition value, macros and an image in the response.
    """;

    try {
      final response = await _recipeService.fetchRecipe(prompt);
      final responses = parseRecipeJson(response['choices'][0]['message']['content']);
      recommendations = List<Map<String, dynamic>>.from(responses['recipes']);
      log('Controller: $recommendations');

      // Start generating images
      generateRecipeImages();
    } catch (error) {
      log('Error: $error');
    } finally {
      isLoadingRecipes.value = false;
    }
  }

  Future<void> generateRecipeImages() async {
    isLoadingImages.value = true;
    imageUrls.clear(); // Clear previous image URLs

    for (var recipe in recommendations) {
      final description = recipe['description'];
      try {
        final imageUrl = await _recipeService.generateRecipeImage(description);
        imageUrls.add(imageUrl);
      } catch (error) {
        log('Error generating image: $error');
        imageUrls.add(''); // Add an empty string to maintain list consistency
      }
    }

    isLoadingImages.value = false;
  }
}
