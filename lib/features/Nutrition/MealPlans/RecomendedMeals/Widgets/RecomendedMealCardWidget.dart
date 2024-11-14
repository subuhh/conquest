import "package:cached_network_image/cached_network_image.dart";
import "package:conquest/core/model/Nutrition/recipe_model.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:shimmer/shimmer.dart";
import "../../../../../utils/constants/sizes.dart";
import 'package:get/get.dart';
import "../../../MealRecipes/MealRecipePage.dart";

Widget RecommendedMealCardSmall(BuildContext context, RecipeModel recipe) {
  Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: GestureDetector(
      onTap: () => Get.to(
        () => MealRecipesPage(recipe: recipe),
      ),
      child: SizedBox(
        width: size.width * 0.65,
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.imageUrl,
                      height: size.height * 0.2,
                      width: size.width * 0.65,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: size.height * 0.2,
                          width: size.width * 0.65,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        // final userId = AuthService.instance.currentUser!.uid;
                        // await favoriteController.toggleFavorite(
                        //     userId, recipeJson);
                      },
                      child: CircleAvatar(
                        radius: 16.5,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.55,
                      child: Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/nutrition/newMeal.svg',
                          height: 18,
                          colorFilter:
                              ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems / 2),
                        Text(
                          '${recipe.calories}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/nutrition/Stopwatch.svg',
                          height: 18,
                          colorFilter:
                              ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems / 2),
                        Text(
                          '${recipe.prepTime}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
