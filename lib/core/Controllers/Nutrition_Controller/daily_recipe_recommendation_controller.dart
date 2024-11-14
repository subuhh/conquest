// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
// import '../user_controller.dart';
//
// class DailyRecipeRecommendationController extends GetxController {
//   static DailyRecipeRecommendationController get instance => Get.find();
//
//   final _formKey = GlobalKey<FormState>();
//   GlobalKey<FormState> get formKey => _formKey;
//   final recipeController = Get.put(RecipeController());
//
//   var selectedDiet = ''.obs;
//   var mealType = ''.obs;
//   var timeOfDay = ''.obs;
//   var calories = 0.0.obs;
//   var isLoadingRecipes = false.obs;
//   var isLoadingImages = false.obs;
//   List<Map<String, dynamic>> recommendations = [];
//   var imageUrls = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeUserData();
//     _setMealType();
//   }
//
//   void _initializeUserData() {
//     final userController = UserController.instance;
//     var diets =
//         userController.userModel.value?.dietPreference ?? ['Vegetarian'];
//     selectedDiet.value = diets.join(', ');
//     calories.value =
//         userController.userModel.value?.calorieGoal?.toDouble() ?? 450.0;
//   }
//
//   void _setMealType() {
//     final hour = DateTime.now().hour;
//     if (hour < 10) {
//       mealType.value = 'Breakfast';
//       timeOfDay.value = 'Morning';
//     } else if (hour < 14) {
//       mealType.value = 'Lunch';
//       timeOfDay.value = 'Afternoon';
//     } else if (hour < 18) {
//       mealType.value = 'Snack';
//       timeOfDay.value = 'Evening';
//     } else {
//       mealType.value = 'Dinner';
//       timeOfDay.value = 'Night';
//     }
//   }
//
//
//
//   // final ChatGptRecipeService _recipeService = ChatGptRecipeService();
//   //
//   // Map<String, dynamic> parseRecipeJson(String recipe) {
//   //   return jsonDecode(recipe);
//   // }
//
//   // String _generateRecipeHash(Map<String, dynamic> recipe) {
//   //   final title = recipe['title'];
//   //   final data = '$title';
//   //   return sha256.convert(utf8.encode(data)).toString();
//   // }
//   //
//   // Future<bool> _isRecipeInDatabase(String hash) async {
//   //   final querySnapshot = await FirebaseFirestore.instance
//   //       .collection('recipes')
//   //       .where('hash', isEqualTo: hash)
//   //       .get();
//   //   return querySnapshot.docs.isNotEmpty;
//   // }
//
//   // Future<void> _saveRecipeToFirebase(
//   //     Map<String, dynamic> recipe, String imageUrl, String hash) async {
//   //   try {
//   //     final recipeModel = {
//   //       'title': recipe['title'],
//   //       'description': recipe['description'],
//   //       'ingredients': recipe['ingredients'],
//   //       'steps': recipe['steps'],
//   //       'calories': recipe['calories'],
//   //       'recipeTime': recipe['recipeTime'],
//   //       'nutritionValue': recipe['nutritionValue'],
//   //       'imageUrl': imageUrl,
//   //       'dietPreference': selectedDiet.value,
//   //       'mealType': mealType.value,
//   //       'hash': hash,
//   //       'createdAt': FieldValue.serverTimestamp(),
//   //     };
//   //
//   //     await FirebaseFirestore.instance.collection('recipes').add(recipeModel);
//   //     log('Recipe saved: ${recipe['title']}');
//   //   } catch (e) {
//   //     log('Error saving recipe: $e');
//   //   }
//   // }
//
//   // Future<void> fetchChatGPTRecipe() async {
//   //   isLoadingRecipes.value = true;
//   //
//   //   final prompt = """
//   //   Suggest only three Indian recipes in the format of json for a ${selectedDiet.value}
//   //   meal under ${calories.value.round()} calories, suitable for ${mealType.value}. Please
//   //   include the recipe title, a brief description, ingredients, steps, calorie, recipe time,
//   //   nutrition value, macros and an image in the response.
//   //   """;
//   //
//   //   try {
//   //     final response = await _recipeService.fetchRecipe(prompt);
//   //     final responses =
//   //         parseRecipeJson(response['choices'][0]['message']['content']);
//   //     recommendations = List<Map<String, dynamic>>.from(responses['recipes']);
//   //     log('Controller: $recommendations');
//   //
//   //     // Start generating images
//   //     await generateRecipeImages();
//   //   } catch (error) {
//   //     log('Error: $error');
//   //   } finally {
//   //     isLoadingRecipes.value = false;
//   //   }
//   // }
//
//   // Future<void> generateRecipeImages() async {
//   //   isLoadingImages.value = true;
//   //   imageUrls.clear(); // Clear previous image URLs
//   //
//   //   for (var recipe in recommendations) {
//   //     final description = recipe['description'];
//   //     try {
//   //       // Generate the image url
//   //       final imageUrl = await _recipeService.generateRecipeImage(description);
//   //       log('$description: $imageUrl');
//   //       imageUrls.add(imageUrl);
//   //
//   //       final recipeHash = _generateRecipeHash(recipe);
//   //
//   //       final exists = await _isRecipeInDatabase(recipeHash);
//   //       if (!exists) {
//   //         // Save recipe to Firebase if it's unique
//   //         await _saveRecipeToFirebase(recipe, imageUrl, recipeHash);
//   //       } else {
//   //         log('Recipe already exists: ${recipe['title']}');
//   //       }
//   //     } catch (error) {
//   //       log('Error generating image: $error');
//   //       imageUrls.add(''); // Add an empty string to maintain list consistency
//   //     }
//   //   }
//   //
//   //   isLoadingImages.value = false;
//   // }
// }
