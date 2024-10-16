import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../MealRecipes/MealRecipePage.dart';

class DailyRecommendedMeal extends StatelessWidget {
  const DailyRecommendedMeal({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MealRecipesPage()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems / 2),
            child: Text(
              'Recomended meal',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 300,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Image.network(
                        'https://www.eatingwell.com/thmb/QYZnBgF72TIKI6-A--NyoPa6avY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/greek-salmon-bowl-f681500cbe054bb1adb607ff55094075.jpeg',
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                              color: Colors.white,
                            ),
                            height: 20,
                            width: 150,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/icons/nutrition/Stopwatch.svg',height: 20,),
                                SizedBox(width: TSizes.spaceBtwItems/4,),
                                Text('25 mins'),
                                SizedBox(width: TSizes.spaceBtwItems/4,),
                                Text('•'),
                                SizedBox(width: TSizes.spaceBtwItems/4,),
                                Text('7 items')
      
                                //Icon(Icons.)
                              ],
                              
                            ),
      
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:TSizes.spaceBtwItems,left:TSizes.spaceBtwItems ),
                  child: Text(
                    'Chicken Vegies',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(fontWeightDelta: 2),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
                  child: Column(
      
                    children: [
                      Text(
                        'Calories 500',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Protein 20g',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )
      
      
      
                //Text("Customize")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
