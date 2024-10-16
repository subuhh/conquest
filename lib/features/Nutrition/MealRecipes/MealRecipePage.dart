import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../WIdgets/MealNutritionIndicator/MealNutritionIndicator.dart';

final List<String> directions = [
  "Heat a large skillet over medium-high heat. Add oil to the pan and swirl to coat. Add beef and cook, turning occasionally until browned on all sides, 6–8 minutes.",
  "Spoon beef into a 6-quart slow cooker. Stir in chicken stock, onion, garlic, chili powder, chipotles, salt, beans and tomatoes. Cover and cook on low until beef and beans are tender, 7–8 hours.",
  "Ladle chili evenly into bowls. Top with sour cream, radishes, green onions and cilantro."
];

class MealRecipesPage extends StatelessWidget {
  const MealRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.network(
                'https://www.eatingwell.com/thmb/QYZnBgF72TIKI6-A--NyoPa6avY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/greek-salmon-bowl-f681500cbe054bb1adb607ff55094075.jpeg',
                width: double.maxFinite,
                height: 250,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chicken Vegies',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(fontWeightDelta: 2),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections / 2,
                  ),
                  Text(
                    'Nutrition per Serving',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Mealnutritionindicatorwidget(),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        '1 1/2 tablespoon canola oil\n'
                        '1 1/2 pound beef stew meat, cut into 3/4-inch pieces\n'
                        '5 cup unsalted chicken stock\n'
                        '2 cup chopped onion\n',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: directions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: '${index + 1}. ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    TextSpan(text: directions[index]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
