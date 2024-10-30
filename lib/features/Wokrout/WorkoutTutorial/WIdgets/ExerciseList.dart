import 'package:conquest/features/Wokrout/WorkoutTutorial/WIdgets/ExerciseCard.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';


class Exerciselist extends StatefulWidget {
  const Exerciselist({super.key});

  @override
  _ExerciselistState createState() => _ExerciselistState();
}

class _ExerciselistState extends State<Exerciselist> {
  bool isExpanded = false; // Track whether the list is expanded

  @override
  Widget build(BuildContext context) {
    // Example data length
    int totalItems = 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: TSizes.spaceBtwItems),
            VerticalDivider(thickness: 3, color: TColors.primary),
            Text(
              "Preview",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true, // Ensures the ListView takes up minimal space
            physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
            itemCount: isExpanded ? totalItems : 5, // Show 5 or all items
            itemBuilder: (context, index) {
              // Format index with leading zero
              String formattedIndex = (index + 1).toString().padLeft(2, '0');

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      formattedIndex, // Display the formatted index
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Exercisecard(),
                  ],
                ),
              );
            },
          ),
        ),
        if (totalItems > 5) // Show the expand button only if there are more than 5 items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle the expanded state
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isExpanded ? "Show Less" : "Show More", style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.grey),),
                  Icon(isExpanded? Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,color: Colors.grey,)
                ],
              ),
            ),
          ),
      ],
    );
  }
}
