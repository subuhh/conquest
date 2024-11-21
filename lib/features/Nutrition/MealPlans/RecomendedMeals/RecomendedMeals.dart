import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Meals',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                    GestureDetector(
                      onTap: recipeController.reloadRecipes,
                      child:
                          SvgPicture.asset('assets/icons/nutrition/update.svg'),
                    )
                  ],
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                if (recipeController.isLoading.value) ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1, // Number of shimmer items
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context)
                                .size
                                .width, // Width of each shimmer container
                            height: MediaQuery.of(context).size.height *
                                0.3, // Height of each shimmer container
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ] else ...[
                  RecommendedMealCarousel(context, recipeController.recipes)
                ],
              ],
            ),
    );
  }
}
