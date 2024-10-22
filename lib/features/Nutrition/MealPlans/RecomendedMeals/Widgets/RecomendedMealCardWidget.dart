import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "../../../../../core/Controllers/Nutrition_Controller/Chat_Gpt_Controller/chat_gpt_controller.dart";
import "../../../../../utils/constants/sizes.dart";
import "../../../MealRecipes/MealRecipePage.dart";

Widget RecommendedMealCardSmall(
  BuildContext context,
  Map<String, dynamic> recipeJson,
  RecipeRecommendationChatGptController controller,
  String url,
) {
  // final favoriteController = RecipeFavoriteController.instance;
  // final isFavorite = favoriteController.favoriteRecipes
  //     .any((recipe) => recipe['id'] == recipeJson['id']);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems / 4),
    child: GestureDetector(
      onTap: () => Get.to(
        () => MealRecipesPage(
          recipe: recipeJson,
          controller: controller,
          url: url,
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset('assets/images/recipe_image_error.png'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/recipe_image_error.png'),
                  ),
                ),
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: GestureDetector(
                //     onTap: () async {
                //       // final userId = AuthService.instance.currentUser!.uid;
                //       // await favoriteController.toggleFavorite(
                //       //     userId, recipeJson);
                //     },
                //     child: CircleAvatar(
                //       backgroundColor: Colors.white,
                //       child: Icon(
                //         Icons.favorite_border,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.spaceBtwItems / 2,
                vertical: TSizes.spaceBtwItems / 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeJson['title'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.spaceBtwItems / 4),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/nutrition/newMeal.svg',
                          height: 16,
                          colorFilter:
                              ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems / 2),
                        Text(
                          '${recipeJson['calories']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/nutrition/Stopwatch.svg',
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                      ),
                      SizedBox(width: TSizes.spaceBtwItems / 2),
                      Text(
                        '${recipeJson['recipeTime']}',
                        style: Theme.of(context).textTheme.bodySmall,
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
  );
}
