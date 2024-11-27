import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/sizes.dart';
import '../../WorkoutTutorial/workout_plan_page.dart';

class WorkoutPlanCardLarge extends StatelessWidget {
  const WorkoutPlanCardLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => WorkoutPlanPage());
        },
        child: Stack(
          children: [
            // Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/icons/Workout/img.png',
                height: 300,
                width: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
            // Black film overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            // Top text
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 25,
                    width: 50,
                    child: Center(
                      child: Text(
                        '21/21',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 25,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Uncompleted',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom text
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Text(
                    "GYM Back Strengthening",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: Colors.white, fontWeightDelta: 25),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    "23 mins / 142 kal / Intermediate",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(color: Colors.white),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems / 2),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.all(5)),
                      onPressed: () {},
                      child: const Text("Start"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
