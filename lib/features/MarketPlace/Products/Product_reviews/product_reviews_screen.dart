import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/UserReviewCard.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'RatingBarIndicator.dart';
import 'overall_rating_indicator.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Sectionheading(
          title: 'Rating and Reviews',
          showActionButton: false,
          isPadding: true,
          isHeader: true,
        ),
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Review and reviews are verfies and are from people who use the same type of device that you use."),
              const SizedBox(height: TSizes.spaceBtwItems),

              ///Overall Product Rating
              const OverallRatingIndicator(),
              const TRatingBarIndicator(rating: 3.5),

              Text(
                "12,611",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// User Review List

              const UserReviewCard(),
              const SizedBox(height: TSizes.spaceBtwSections),
              const UserReviewCard(),
              const SizedBox(height: TSizes.spaceBtwItems),
              // Text Button See all review
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all 710 reviews',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
