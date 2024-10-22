import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Controllers/Nutrition_Controller/Chat_Gpt_Controller/chat_gpt_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../Widgets/MealNutritionIndicator/MealNutritionIndicator.dart';

class MealRecipesPage extends StatelessWidget {
  const MealRecipesPage(
      {super.key,
      required this.recipe,
      required this.controller,
      required this.url});

  final Map<String, dynamic> recipe;
  final RecipeRecommendationChatGptController controller;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      width: double.maxFinite,
                      height: 250,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) =>
                          Image.asset('assets/images/recipe_image_error.png'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/recipe_image_error.png'),
                    ),
                  ),
                  Positioned(
                    top: 10,
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
                  // Positioned(
                  //   top: 10,
                  //   right: 10,
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     child: Icon(
                  //       Icons.favorite_border,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.spaceBtwItems),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'],
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(fontWeightDelta: 2),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections / 2),
                    Text(
                      'Nutrition per ${recipe['nutritionValue']['servings'] ?? '1'} Serving',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    MealNutritionIndicatorWidget(recipe: recipe),
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
                        ...recipe['ingredients'].map<Widget>((ingredientItem) {
                          final ingredient = ingredientItem['ingredient'];
                          final quantity = ingredientItem['quantity'];
                          return Text(
                            '• $ingredient: $quantity',
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
                        ...recipe['steps'].map<Widget>((step) {
                          return Text(
                              '${recipe['steps'].indexOf(step) + 1}. ${step['instruction']}',
                              style: const TextStyle(fontSize: 16));
                        }).toList(),
                        SizedBox(height: TSizes.spaceBtwItems * 2),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
