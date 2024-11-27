import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';


class DailyProgressBarIndicator extends StatelessWidget {
  final int progress=10;
  final int total = 21;

  DailyProgressBarIndicator();

  @override
  Widget build(BuildContext context) {
    double progressPercentage = progress / total;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Today's Progress $progress/$total",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: TColors.darkGrey),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(5),
              value: 0.5,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              color: TColors.primary,
            ),
            SizedBox(
              height: TSizes.spaceBtwItems,
            )
          ],
        ),
        Positioned(
            right: 0,
            bottom: TSizes.spaceBtwItems/2,
            child: Image.asset(
                height: 30,
                'assets/images/GiftBox.png')),
      ],
    );
  }
}
