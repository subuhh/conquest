import 'package:conquest/features/MarketPlace/Products/Product_reviews/RatingBarIndicator.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard(
      {super.key,
      required this.username,
      required this.rating,
      required this.title,
      required this.reviewText,
      required this.date});

  final String username;
  final String title;
  final double rating;
  final String reviewText;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final String formattedBookingDate = DateFormat('dd MMM, yyyy').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(username[0].toUpperCase()),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),

        // Star and Date
        Row(
          children: [
            TRatingBarIndicator(rating: rating),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(formattedBookingDate,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Title
        Text(
          title,
          style: TTextTheme.lightTextTheme.titleLarge,
        ),

        // Review
        ReadMoreText(
          reviewText,
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' Show Less',
          trimCollapsedText: ' Show More',
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary),
          lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }
}
