import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/screens/MarketPlace/Products/Product_reviews/UserReviewCard.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

import 'RatingBarIndicator.dart';
import 'overall Rating Indicator.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Sectionheading(
                  title: 'Review & Ratings',
                  showActionButton: false,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Review and reviews are verfies and are from people who use the same type of device that you use."),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  ///Overall Product Rating
                  OverallRatingIndicator(),
                  TRatingBarIndicator(rating:3.5),

                  Text(
                    "12,611",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// User Review List

                  UserReviewCard(),
                  const SizedBox(height: TSizes.spaceBtwSections,),
                  UserReviewCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
