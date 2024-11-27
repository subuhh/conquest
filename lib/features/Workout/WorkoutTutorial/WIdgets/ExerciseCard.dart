// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import '../../../../utils/constants/sizes.dart';
//
// class ExerciseCard extends StatelessWidget {
//   final Map<String, dynamic> exercise;
//   const ExerciseCard({super.key, required this.exercise});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(
//           vertical: TSizes.spaceBtwItems / 2, horizontal: TSizes.spaceBtwItems),
//       leading: CachedNetworkImage(
//         imageUrl: exercise['gifUrl'] ?? '',
//         height: 120,
//         width: 100,
//         fit: BoxFit.cover,
//         errorWidget: (context, error, stackTrace) =>
//             const Icon(Icons.broken_image),
//       ),
//       title: Text(
//         capitalizeFirstLetter(exercise['name'] ?? 'Unknown Exercise'),
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//         style: Theme.of(context).textTheme.headlineSmall,
//       ),
//       subtitle: Text(
//         capitalizeFirstLetter(exercise['target'] ?? 'Unknown Target'),
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//     );
//   }
// }
//
// String capitalizeFirstLetter(String input) {
//   if (input.isEmpty) return input; // Return the input if it's empty
//   return input[0].toUpperCase() + input.substring(1);
// }
