import 'dart:developer';

import 'package:get/get.dart';
import '../../model/Nutrition/common_food_model.dart';
import '../../services/nutrition/common_food_service.dart';

class CommonFoodController extends GetxController {
  static CommonFoodController get instance => Get.find();
  final _nutritionService = Get.put(CommonFoodService());

  var nutritionData = <NutritionItem>[].obs;
  var filteredData = <NutritionItem>[].obs;
  var selectedIngredients = <NutritionItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    log('Fetching Common Data');
    fetchNutritionData();
    log('Finished Common Data');
  }

  // Fetch nutrition data from Firebase
  Future<void> fetchNutritionData() async {
    isLoading(true);
    try {
      // Fetch data from Firebase
      List<NutritionItem> items = await _nutritionService.fetchNutritionData();
      nutritionData.assignAll(items);
      filteredData
          .assignAll(items.take(5).toList()); // Show only 5 items initially
    } catch (e) {
      log("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Filter foods based on the search query
  void filterFoods(String query) {
    if (query.isEmpty) {
      filteredData.assignAll(nutritionData);
    } else {
      filteredData.assignAll(
        nutritionData
            .where((item) =>
                item.foodName.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  // Add an ingredient to the selected list
  void addIngredient(NutritionItem item) {
    if (selectedIngredients.length < 5) {
      selectedIngredients.add(item);
    } else {
      Get.snackbar("Limit reached", "You can only add up to 5 ingredients.");
    }
  }
}
