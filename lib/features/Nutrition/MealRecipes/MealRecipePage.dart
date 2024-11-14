import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/model/Nutrition/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/constants/sizes.dart';
import '../Widgets/MealNutritionIndicator/MealNutritionIndicator.dart';

class MealRecipesPage extends StatelessWidget {
  const MealRecipesPage({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    width: double.maxFinite,
                    height: size.height * 0.3,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 0.65,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              // Recipe Meta Data
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.spaceBtwItems),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(fontWeightDelta: 2),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections / 2),
                    // Nutrition Indicator
                    Text(
                      'Nutrition per 100g',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    MealNutritionIndicatorWidget(recipe: recipe),
                    // MealNutritionIndicatorWidget(recipe: recipe),
                    SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ...recipe.ingredients.map<Widget>((ingredient) {
                          return Text(
                            '• $ingredient',
                            style: const TextStyle(fontSize: 16),
                          );
                        }).toList(),
                        SizedBox(height: TSizes.spaceBtwItems),
                        // Recipe Steps
                        const Text(
                          'Steps',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ...recipe.instructions.map<Widget>((step) {
                          return Text(
                            '${recipe.instructions.indexOf(step) + 1}. $step',
                            style: const TextStyle(fontSize: 16),
                          );
                        }).toList(),
                        SizedBox(height: TSizes.spaceBtwItems * 2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
