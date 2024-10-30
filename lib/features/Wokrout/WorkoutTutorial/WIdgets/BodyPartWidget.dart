import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';


class Bodypartwidget extends StatelessWidget {
  const Bodypartwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Wrap VerticalDivider with Container and set width
              Container(
                width: 8, // Define width for the VerticalDivider
                child: VerticalDivider(
                  thickness: 3,
                  color: TColors.primary,
                ),
              ),
              SizedBox(width: 8), // Add space between divider and text
              Text(
                "Body Part",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(
            height: TSizes.spaceBtwItems / 1.5,
          ),
          Row(
            children: [
              SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  color: TColors.softGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Chest",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'assets/icons/Workout/chest.png',
                        fit: BoxFit.fill,
                        height: double.maxFinite,
                      ),

                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
