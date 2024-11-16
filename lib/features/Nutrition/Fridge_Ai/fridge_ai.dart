import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/Controllers/Nutrition_Controller/fridge_ai_recipe_generator_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/loaders.dart';

class FridgeAIPage extends StatelessWidget {
  const FridgeAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final controller = Get.put(FridgeAIRecipeGeneratorController());

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('FridgeAI'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (controller.isLoadingRecipes.value &&
                  controller.isLoadingImages.value) {
                // Full-page loading effect
                return Container(
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Generating your personalized meal...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              if (controller.recommendations.isNotEmpty) {
                // Show the generated recipes
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.recommendations.length,
                  itemBuilder: (context, index) {
                    final recipe = controller.recommendations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            controller.imageUrls.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: controller.imageUrls[index])
                                : SizedBox.shrink(),
                            const SizedBox(height: 10),
                            Text(
                              recipe['title'],
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe['description'],
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Calorie: ${recipe['calories']}',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Recipe Time: ${recipe['recipeTime']}',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe['description'],
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            // Ingredients
                            Text(
                              "Ingredients:",
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipe['ingredients']?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${index + 1}. ${recipe['ingredients'][index]['ingredient']}: ${recipe['ingredients'][index]['quantity']}",
                                  style: textTheme.bodySmall,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            // Steps
                            Text(
                              "Steps:",
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipe['steps']?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${index + 1}. ${recipe['steps'][index]['instruction']}",
                                  style: textTheme.bodySmall,
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Nutritional Values
                            Text(
                              "Nutritional Values:",
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            recipe['nutritionValue'] != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: recipe['nutritionValue']
                                        .entries
                                        .map<Widget>(
                                          (entry) => Text(
                                            "${entry.key.toString().toUpperCase()}: ${entry.value}",
                                            style: textTheme.bodySmall,
                                          ),
                                        )
                                        .toList(),
                                  )
                                : Text(
                                    "No nutritional information available.",
                                    style: textTheme.bodySmall,
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "Add Ingredients & Details",
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: TColors.softGrey,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/nutrition/newMeal.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.grey, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Add ingredients from your fridge to create a healthy, personalized meal!",
                                    textAlign: TextAlign.center,
                                    style: textTheme.titleSmall!
                                        .apply(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Ingredients (comma-separated)",
                              hintText: "e.g., eggs, milk, flour",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              controller.selectedIngredients.value = value
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList();
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Maximum Calories",
                              hintText: "e.g., 500",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              controller.maxCalories.value =
                                  int.tryParse(value) ?? 0;
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Macros (Protein, Fiber ..)",
                              hintText: "e.g., protein:10g, fiber:5g",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              final macros = <String, dynamic>{};
                              value.split(',').forEach((macro) {
                                final parts = macro.split(':');
                                if (parts.length == 2) {
                                  macros[parts[0].trim()] = parts[1].trim();
                                }
                              });
                              controller.macros.value = macros;
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TextField(
                            decoration: const InputDecoration(
                              labelText:
                                  "Add your personal touch or specific instructions!",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              controller.personalTouch.value = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: controller.recommendations.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedIngredients.length < 2) {
                    TLoaders.errorSnackBar(
                        title: "Error",
                        message: "Please add at least two ingredients.");
                  } else {
                    controller.fetchChatGPTRecipe();
                  }
                },
                child: const Text("Generate Meal"),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
