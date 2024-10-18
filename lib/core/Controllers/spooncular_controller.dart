import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:get/get.dart';
import '../services/spooncular_service.dart';

class MealRecommendationController extends GetxController {
  var isLoading = true.obs;
  var recommendedMeals = <Map<String, dynamic>>[].obs;

  final userController = UserController.instance;

  final SpoonacularService spoonacularService = SpoonacularService();

  // Fetch meals directly when the controller is initialized
  @override
  void onInit() {
    super.onInit();

    // Get the meal type based on the current time
    // String mealType = _getMealTypeBasedOnTime();

    // Fetch recommended meals when the controller is initialized
    fetchRecommendedMeals(
      diet: userController.userModel.value!.dietPreference![0],
      maxCalories: userController.userModel.value!.calorieGoal!.round() ~/ 5,
      mealType: 'breakfast',
      numberOfRecipes: 1,
    );
  }

  // Fetch recommended meals and their details
  Future<void> fetchRecommendedMeals({
    required String diet,
    required int maxCalories,
    required String mealType,
    required int numberOfRecipes,
  }) async {
    isLoading.value = true;
    try {
      var mealPlan = await spoonacularService.getRecipes(
        diet: diet,
        maxCalories: maxCalories,
        mealType: mealType,
        numberOfRecipes: numberOfRecipes,
      );

      // Fetch details for each recipe
      var detailedMeals = await Future.wait(
        mealPlan.map((meal) async {
          return await spoonacularService.getRecipeDetails(meal['id']);
        }).toList(),
      );

      recommendedMeals.value = detailedMeals; // Store detailed meal data
    } catch (e) {
      print("Failed to fetch meal data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper function to determine meal type based on the current time
  // String _getMealTypeBasedOnTime() {
  //   final now = DateTime.now();
  //   final hour = now.hour;
  //
  //   if (hour >= 5 && hour < 10) {
  //     return 'breakfast';
  //   } else if (hour >= 11 && hour < 14) {
  //     return 'lunch';
  //   } else if (hour >= 18 && hour < 21) {
  //     return 'dinner';
  //   } else {
  //     return 'snack'; // Default to snack or other if outside meal time ranges
  //   }
  // }
}
