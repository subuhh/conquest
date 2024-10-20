import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "../../../../../utils/constants/sizes.dart";
import "../../../MealRecipes/MealRecipePage.dart";



Widget RecomendedMealCardSmall(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems/4),
    child: GestureDetector(
      onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (ctx)=>MealRecipesPage())),
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
                  child: Image.network(
                    'https://assets.clevelandclinic.org/transform/a35aef83-8f90-4738-8ced-fee64e4ed789/meal-Prepping-Food-Containers-1271087035-967x544-1_jpg',
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems/2,vertical: TSizes.spaceBtwItems/6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meal Name",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems/4),
                    child:  Row(
                      children: [
                        SvgPicture.asset('assets/icons/calorie.svg', height: 16,color: Colors.orange),
                        SizedBox(width: TSizes.spaceBtwItems/2),

                        Text(
                          "300 cal",
                          style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/Stopwatch.svg', height: 16,),
                      SizedBox(width: TSizes.spaceBtwItems/2),

                      Text(
                        "30 mins",
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