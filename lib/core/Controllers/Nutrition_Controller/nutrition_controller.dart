import 'dart:developer';
import 'package:conquest/core/services/auth_service.dart';
import 'package:get/get.dart';

import '../../model/Nutrition/nutrition_model.dart';
import '../../services/nutrition/nutrition_service.dart';

class NutritionController extends GetxController {
  static NutritionController get instance => Get.find();

  final NutritionService _nutritionService = NutritionService();
  String userId = AuthService.instance.currentUser!.uid;

  // Observables
  var isLoading = false.obs;
  var meals = <String, List<Meal>>{}.obs; // Store meals by mealTiming

  // RxMap to dynamically manage calories per meal
  var mealCalories = {
    "breakfast": 0.obs,
    "morningsnack": 0.obs,
    "lunch": 0.obs,
    "eveningsnack": 0.obs,
    "dinner": 0.obs,
  }.obs;

  var mealMacros = {
    "breakfast": {"protein": 0.0, "fat": 0.0, "carbs": 0.0, "fiber": 0.0}.obs,
    "morningsnack":
        {"protein": 0.0, "fat": 0.0, "carbs": 0.0, "fiber": 0.0}.obs,
    "lunch": {"protein": 0.0, "fat": 0.0, "carbs": 0.0, "fiber": 0.0}.obs,
    "eveningsnack":
        {"protein": 0.0, "fat": 0.0, "carbs": 0.0, "fiber": 0.0}.obs,
    "dinner": {"protein": 0.0, "fat": 0.0, "carbs": 0.0, "fiber": 0.0}.obs,
  }.obs;

  // Observable for total calories
  var totalCalories = 0.0.obs;

  var totalMacros = {
    "protein": 0.0.obs,
    "fat": 0.0.obs,
    "carbs": 0.0.obs,
    "fiber": 0.0.obs,
  }.obs;

  void onInit() async {
    super.onInit();
    await fetchMeals();
  }

  /// Get meals for a specific meal type (timing)
  List<Meal> getMealItems(String mealTiming) {
    return meals[mealTiming] ?? [];
  }

  /// Add or Update a meal
  Future<void> addOrUpdateMeal(String mealType, Meal mealData) async {
    isLoading(true);
    try {
      // Add or update meal in the service
      await _nutritionService.addOrUpdateNutrition(userId, mealType, mealData);

      // Update the local state
      if (meals.containsKey(mealType)) {
        meals[mealType]!.add(mealData); // Add to existing list
      } else {
        meals[mealType] = [mealData]; // Create new list
      }

      // Update calories for the meal type
      mealCalories[mealType]?.value =
          meals[mealType]?.fold(0, (sum, meal) => sum! + meal.totalCalories) ??
              0;

      mealMacros[mealType]?.update(
        "protein",
        (prev) =>
            meals[mealType]
                ?.fold(0.0, (sum, meal) => sum! + meal.macros['proteinG']!) ??
            0.0,
      );
      mealMacros[mealType]?.update(
        "fat",
        (prev) =>
            meals[mealType]
                ?.fold(0.0, (sum, meal) => sum! + meal.macros['fatG']!) ??
            0.0,
      );
      mealMacros[mealType]?.update(
        "carbs",
        (prev) =>
            meals[mealType]
                ?.fold(0.0, (sum, meal) => sum! + meal.macros['carbG']!) ??
            0.0,
      );
      // mealMacros[mealType]?.update(
      //   "fiber",
      //       (prev) => meals[mealType]?.fold(0.0, (sum, meal) => sum! + meal.fiber) ?? 0.0,
      // );

      // Recalculate total calories
      _calculateTotalCalories();
      _calculateTotalMacros();

      meals.refresh();
      mealCalories.refresh();
      mealMacros.refresh();
    } catch (e) {
      // Handle error
      log('"Failed to update meal: $e"');
    } finally {
      isLoading(false);
    }
  }

  /// Remove a meal
  // Future<void> removeMeal(String mealType, int mealIndex, Meal meal) async {
  //   isLoading(true);
  //   try {
  //     // Remove meal from the service
  //     await _nutritionService.removeMeal(userId, mealType, meal);
  //
  //     // Update local state
  //     meals[mealType]?.removeAt(mealIndex);
  //
  //     // Update calories for the meal type
  //     mealCalories[mealType]?.value =
  //         meals[mealType]?.fold(0, (sum, meal) => sum! + meal.totalCalories) ??
  //             0;
  //
  //     mealMacros[mealType]?.update(
  //       "protein",
  //       (prev) =>
  //           meals[mealType]
  //               ?.fold(0.0, (sum, meal) => sum! + meal.macros['proteinG']!) ??
  //           0.0,
  //     );
  //     mealMacros[mealType]?.update(
  //       "fat",
  //       (prev) =>
  //           meals[mealType]
  //               ?.fold(0.0, (sum, meal) => sum! + meal.macros['fatG']!) ??
  //           0.0,
  //     );
  //     mealMacros[mealType]?.update(
  //       "carbs",
  //       (prev) =>
  //           meals[mealType]
  //               ?.fold(0.0, (sum, meal) => sum! + meal.macros['carbG']!) ??
  //           0.0,
  //     );
  //
  //     // Recalculate total calories
  //     _calculateTotalCalories();
  //     _calculateTotalMacros();
  //
  //     meals.refresh();
  //     mealCalories.refresh();
  //     mealMacros.refresh();
  //
  //     // Notify success
  //     TLoaders.successSnackBar(
  //         title: "Success", message: "Meal removed successfully!");
  //   } catch (e) {
  //     // Handle error
  //     log("Failed to remove meal: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  /// Fetch meals from the service and update local state
  Future<void> fetchMeals({DateTime? date}) async {
    isLoading(true);
    try {
      final targetDate = date ?? DateTime.now();

      final fetchedMeals = await _nutritionService.getMeals(userId, targetDate);

      if (fetchedMeals.isEmpty) {
        // Reset meals and their calories/macros if no data is found
        meals['breakfast'] = [];
        meals['morningsnack'] = [];
        meals['lunch'] = [];
        meals['eveningsnack'] = [];
        meals['dinner'] = [];

        mealCalories.forEach((key, value) {
          value.value = 0;
        });

        mealMacros.forEach((mealType, macros) {
          macros['protein'] = 0.0;
          macros['fat'] = 0.0;
          macros['carbs'] = 0.0;
        });
      }

      log('Fetched Meal: $fetchedMeals');

      meals['breakfast'] = [fetchedMeals['breakfast'] ?? Meal.empty()];
      meals['morningsnack'] = [fetchedMeals['morningsnack'] ?? Meal.empty()];
      meals['lunch'] = [fetchedMeals['lunch'] ?? Meal.empty()];
      meals['eveningsnack'] = [fetchedMeals['eveningsnack'] ?? Meal.empty()];
      meals['dinner'] = [fetchedMeals['dinner'] ?? Meal.empty()];

      // Update calories for each meal type
      fetchedMeals.forEach((mealType, meal) {
        mealCalories[mealType]?.value = meal.totalCalories;

        log('calorie: $mealCalories');

        // Ensure macros are not null before updating
        mealMacros[mealType]?.update(
          "protein",
          (prev) => meal.macros['proteinG'] ?? 0.0,
        );
        mealMacros[mealType]?.update(
          "fat",
          (prev) => meal.macros['fatG'] ?? 0.0,
        );
        mealMacros[mealType]?.update(
          "carbs",
          (prev) => meal.macros['carbG'] ?? 0.0,
        );
      });

      // Recalculate total calories
      _calculateTotalCalories();
      _calculateTotalMacros();

      // Refresh observables
      meals.refresh();
      mealCalories.refresh();
      mealMacros.refresh();
    } catch (e) {
      log("Failed to fetch meal: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Calculate total calories for the day
  void _calculateTotalCalories() {
    totalCalories.value = mealCalories.values.fold(
      0,
      (sum, calorie) => sum + calorie.value,
    );
  }

  // Calculate total macros for the day
  void _calculateTotalMacros() {
    totalMacros["protein"]!.value = mealMacros.values.fold(
      0.0,
      (sum, macro) => sum + macro["protein"]!,
    );
    totalMacros["fat"]!.value = mealMacros.values.fold(
      0.0,
      (sum, macro) => sum + macro["fat"]!,
    );
    totalMacros["carbs"]!.value = mealMacros.values.fold(
      0.0,
      (sum, macro) => sum + macro["carbs"]!,
    );
  }
}
