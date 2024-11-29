import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../MealRecipes/MealRecipePage.dart';
import 'package:conquest/core/model/Nutrition/recipe_model.dart';

Widget RecommendedMealCarousel(RecipeModel recipe, BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return GestureDetector(
    onTap: () => Get.to(
      () => MealRecipesPage(recipe: recipe),
    ),
    child: Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Full-height image
            CachedNetworkImage(
              imageUrl: recipe.imageUrl,
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: size.height * 0.3,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ),
            // Black gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Title, calories, and protein on top of the gradient
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${recipe.calories} kcal',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${recipe.protein} Protein',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite icon
            // Positioned(
            //   top: 10,
            //   right: 10,
            //   child: GestureDetector(
            //     onTap: () async {
            //       // Add your favorite toggle logic here
            //     },
            //     child: CircleAvatar(
            //       radius: 18,
            //       backgroundColor: Colors.black.withOpacity(0.5),
            //       child: Icon(
            //         Icons.favorite_border,
            //         color: Colors.white,
            //         size: 20,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}
