import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/Controllers/Chat_Gpt_Controller/chat_gpt_controller.dart';
import '../../../../utils/constants/sizes.dart';
import 'Widgets/RecomendedMealCardWidget.dart';

class RecommendedMeals extends StatelessWidget {
  const RecommendedMeals({super.key, this.MealTime = ""});

  final String MealTime;
  @override
  Widget build(BuildContext context) {
    final recipeController = RecipeRecommendationController.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended Meals (${recipeController.mealType})',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.left,
            ),
            Icon(Icons.keyboard_double_arrow_right)
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Obx(() {
          if (recipeController.isLoadingRecipes.value) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Number of shimmer items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 150, // Width of each shimmer container
                        height: 200, // Height of each shimmer container
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          log('${recipeController.recommendations}');

          return SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: recipeController.recommendations.length,
              itemBuilder: (context, index) {
                final recipeJson = recipeController.recommendations[index];
                return RecommendedMealCardSmall(context, recipeJson,
                    recipeController, recipeController.imageUrls[index]);
              },
            ),
          );
        }),
      ],
    );
  }
}
