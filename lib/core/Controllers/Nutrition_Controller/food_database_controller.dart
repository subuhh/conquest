import 'dart:developer';

import 'package:get/get.dart';

import '../../services/nutrition/food_database.dart';

class EdamamController extends GetxController {
  static EdamamController get instance => Get.find();

  final EdamamService _edamamService = EdamamService();

  var isLoading = false.obs;
  var foodResults = <Map<String, dynamic>>[].obs;
  var selectedFoodDetails = Rx<Map<String, dynamic>?>(null);

  Future<void> searchFood(String query) async {
    isLoading(true);
    try {
      final response = await _edamamService.searchFood(query);

      // Parse food hints into a list
      foodResults.value =
          List<Map<String, dynamic>>.from(response['hints'] ?? []);
    } catch (e) {
      log("Failed to fetch food data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchNutrients(Map<String, dynamic> foodData) async {
    isLoading(true);
    try {
      final response = await _edamamService.getNutrients(foodData);
      selectedFoodDetails.value = response;
    } catch (e) {
      log("Failed to fetch nutrients: $e");
    } finally {
      isLoading(false);
    }
  }
}
