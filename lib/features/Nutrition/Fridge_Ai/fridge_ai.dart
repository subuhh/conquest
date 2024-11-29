import 'package:conquest/features/Nutrition/Fridge_Ai/previous_recipe_widget.dart';
import 'package:conquest/features/Nutrition/Fridge_Ai/recipe_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/Controllers/Nutrition_Controller/fridge_ai_recipe_generator_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/loaders.dart';

class FridgeAIPage extends StatelessWidget {
  const FridgeAIPage({super.key});

  Widget _buildLoadingScreen(BuildContext context) {
    return Stack(
      children: [
        // Subtle background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white,
                Colors.blue.shade50.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Lottie Animation with larger size and more prominent positioning
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.7, end: 1.0),
                builder: (context, scale, child) => Transform.scale(
                  scale: scale,
                  child: Lottie.asset(
                    'assets/animation/recipe_generating.json',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Elegant Typography
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade300,
                  ],
                ).createShader(bounds),
                child: Text(
                  "Crafting Your\nPersonalized Recipe",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sophisticated Progress Indicator
              SizedBox(
                width: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue.shade50,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade400,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    minHeight: 8,
                  ),
                ),
              ),

              // Subtle additional text
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Please wait while we prepare something delicious...",
                  style: GoogleFonts.roboto(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 120)
            ],
          ),
        ),

        // Decorative elements
        Positioned(
          top: -50,
          right: -50,
          child: Opacity(
            opacity: 0.2,
            child: Icon(
              Icons.restaurant_menu,
              size: 200,
              color: Colors.blue.shade200,
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Opacity(
            opacity: 0.2,
            child: Icon(
              Icons.soup_kitchen,
              size: 200,
              color: Colors.blue.shade200,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final controller = Get.put(FridgeAIRecipeGeneratorController());

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (controller.recommendations.isNotEmpty) {
              controller.clearRecipeData();
            } else {
              Get.back();
            }
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('FridgeAI'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoadingRecipes.value ||
                controller.isLoadingImages.value) {
              return _buildLoadingScreen(context);
            }

            if (controller.recommendations.isNotEmpty) {
              return SingleChildScrollView(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.recommendations.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final recipe = controller.recommendations[index];
                    return RecipeCard(recipe: recipe, textTheme: textTheme);
                  },
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PreviousRecipeCard(),
                    const SizedBox(height: 50),
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
                            Row(
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
                            const SizedBox(height: TSizes.spaceBtwItems),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Ingredients (comma-separated)",
                                  hintText: "e.g., eggs, milk, flour",
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white),
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
                                  filled: true,
                                  fillColor: Colors.white),
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
                                  filled: true,
                                  fillColor: Colors.white),
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
                                  filled: true,
                                  fillColor: Colors.white),
                              onChanged: (value) {
                                controller.personalTouch.value = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Obx(
        () {
          if (controller.isLoadingRecipes.value ||
              controller.isLoadingImages.value ||
              controller.recommendations.isNotEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
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
          );
        },
      ),
    );
  }
}
