import 'package:conquest/core/Controllers/Nutrition_Controller/food_database_controller.dart';
import 'package:conquest/core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../MealContentPage/MealContentPage.dart';

class TrackingMealListCard extends StatelessWidget {
  const TrackingMealListCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nutritionController = NutritionController.instance;

    final List<String> mealTimings = [
      'breakfast',
      'morningsnack',
      'lunch',
      'eveningsnack',
      'dinner'
    ];

    return Column(
      children: mealTimings.map((mealTiming) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mealTiming.capitalize!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .apply(fontWeightDelta: 1),
                    ),
                    Row(
                      children: [
                        // Wrap only the dynamic calorie text in Obx
                        Obx(() {
                          return Text(
                            "${nutritionController.mealCalories[mealTiming.toLowerCase()]?.value ?? 0} Cal",
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        }),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showFoodSelectionBottomSheet(
                              context, mealTiming),
                          child: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 14,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Wrap the meal list in Obx
                Obx(() {
                  final meals = nutritionController.getMealItems(mealTiming);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return meal.items.isNotEmpty
                          ? ListTile(
                              title: Text(meal.items.first),
                              // subtitle: Text(meal.description),
                              trailing: GestureDetector(
                                onTap: () {
                                  nutritionController.removeMeal(
                                      mealTiming, index,meal);
                                },
                                child: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                              ),
                        // onTap: () => MealContentPage(foodData: ,),
                            )
                          : const SizedBox.shrink();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showFoodSelectionBottomSheet(BuildContext context, String mealTiming) {
    final edamamController = Get.put(EdamamController());
    final TextEditingController searchController = TextEditingController();

    Get.bottomSheet(
      Obx(() {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  // onChanged: commonFoodController.searchFood,
                  decoration: InputDecoration(
                    hintText: "Search food",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        edamamController.searchFood(searchController.text);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: edamamController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : edamamController.foodResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final item =
                                  edamamController.foodResults[index]['food'];
                              return ListTile(
                                title: Text(item['label']),
                                subtitle: Text(
                                    "Calories: ${item['nutrients']['ENERC_KCAL']} kcal"),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  Get.back();
                                  Get.to(
                                    () => MealContentPage(
                                      foodData: item,
                                      mealType: mealTiming,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }
}
