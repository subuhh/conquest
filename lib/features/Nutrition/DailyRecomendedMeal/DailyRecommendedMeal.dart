// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../utils/constants/sizes.dart';
// import '../MealRecipes/MealRecipePage.dart';
//
// class DailyRecommendedMeal extends StatelessWidget {
//   const DailyRecommendedMeal({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final mealController = Get.put(MealRecommendationController());
//
//     return GestureDetector(
//       onTap: () => Get.to(() => MealRecipesPage()),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(TSizes.spaceBtwItems / 2),
//             child: Text(
//               'Recommended Meal',
//               style: Theme.of(context).textTheme.titleLarge,
//               textAlign: TextAlign.left,
//             ),
//           ),
//           Obx(() {
//             // Use Obx to listen to changes in the controller's state
//             if (mealController.isLoading.value) {
//               return Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   height: 300,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300], // Added to ensure visibility
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               );
//             }
//
//             var meal = mealController.recommendedMeals[0];
//
//             return Container(
//               height: 300,
//               width: double.maxFinite,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Stack(
//                       children: [
//                         Image.network(
//                           meal['image'],
//                           height: 200,
//                           width: double.maxFinite,
//                           fit: BoxFit.fitWidth,
//                         ),
//                         Positioned(
//                             bottom: 10,
//                             left: 10,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.white,
//                               ),
//                               height: 30,
//                               width: 150,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SvgPicture.asset(
//                                     'assets/icons/nutrition/Stopwatch.svg',
//                                     height: 20,
//                                   ),
//                                   SizedBox(
//                                     width: TSizes.spaceBtwItems / 4,
//                                   ),
//                                   Text('${meal['readyInMinutes']} mins'),
//                                   SizedBox(
//                                     width: TSizes.spaceBtwItems / 4,
//                                   ),
//                                   Text('•'),
//                                   SizedBox(
//                                     width: TSizes.spaceBtwItems / 4,
//                                   ),
//                                   Text(
//                                       '${meal['extendedIngredients'].length} items')
//                                   //Icon(Icons.)
//                                 ],
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: TSizes.spaceBtwItems, left: TSizes.spaceBtwItems),
//                     child: Text(
//                       meal['title'],
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge!
//                           .apply(fontWeightDelta: 2),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
//                   //   child: Column(
//                   //     children: [
//                   //       Text(
//                   //         'Calories: ${meal['nutrition']['nutrients'][0]['amount']} kcal',
//                   //         style:
//                   //             Theme.of(context).textTheme.titleSmall!.apply(),
//                   //         textAlign: TextAlign.left,
//                   //       ),
//                   //       Text(
//                   //         'Protein: ${meal['nutrition']['nutrients'][1]['amount']}g',
//                   //         style:
//                   //             Theme.of(context).textTheme.titleSmall!.apply(),
//                   //         textAlign: TextAlign.left,
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ),
//             );
//           })
//         ],
//       ),
//     );
//   }
// }
