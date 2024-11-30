import 'package:flutter/material.dart' hide Visibility;
import 'package:get/get.dart';

import '../../model/community/post_model.dart';

class CategoryFilterController extends GetxController {
  // Selected categories
  RxSet<Category> selectedCategories = <Category>{}.obs;

  // Selected visibility options
  RxSet<Visibility> selectedVisibility = <Visibility>{}.obs;

  // Date range filter
  Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  // Search controller
  final TextEditingController searchController = TextEditingController();

  // Engagement filters
  RxInt minLikes = 0.obs;
  RxInt minComments = 0.obs;

  void toggleCategory(Category category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void toggleVisibility(Visibility visibility) {
    if (selectedVisibility.contains(visibility)) {
      selectedVisibility.remove(visibility);
    } else {
      selectedVisibility.add(visibility);
    }
  }

  void selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange.value,
    );

    if (picked != null) {
      selectedDateRange.value = picked;
    }
  }

  void applyFilters() {
    // Implement filter application logic
    Get.back(result: {
      'categories': selectedCategories.toList(),
      'visibility': selectedVisibility.toList(),
      'dateRange': selectedDateRange.value,
      'minLikes': minLikes.value,
      'minComments': minComments.value,
      'searchQuery': searchController.text,
    });
  }

  void resetFilters() {
    selectedCategories.clear();
    selectedVisibility.clear();
    selectedDateRange.value = null;
    minLikes.value = 0;
    minComments.value = 0;
    searchController.clear();
  }
}
