import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/sizes.dart';
import 'Widgets/RecomendedMealCardWidget.dart';

class RecommendedMeals extends StatelessWidget {
  const RecommendedMeals({super.key, this.MealTime = ""});

  final String MealTime;
  @override
  Widget build(BuildContext context) {
    final recipeController = RecipeController.instance;

    return Obx(
      () => recipeController.recipes.isEmpty
          ? const SizedBox.shrink()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Meals',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                if (recipeController.isLoading.value) ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Number of shimmer items
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                  )
                ],
                RecommendedMealCarousel(context, recipeController.recipes)
              ],
            ),
    );
  }
}
