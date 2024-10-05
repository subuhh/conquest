import 'package:flutter/material.dart';

import '../../../core/Controllers/Form_Controller/FormControllr.dart';
import '../../../utils/constants/sizes.dart';

class GoalQuestion extends StatelessWidget {
  GoalQuestion({super.key, required this.controller});

  final FormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {
                  controller.nextQuestion();
                },
                child: Text(
                  "Lose Weight",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {
                  controller.nextQuestion();

                },
                child: Text(
                  "Gain Muscles",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {
                  controller.nextQuestion();

                },
                child: Text(
                  "Build Strength",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
      ],
    );
  }
}
