import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/core/Controllers/Product_Controller/review_controller.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/UserReviewCard.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/add_review_screen.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/rating_progress_indicator.dart';
import 'package:conquest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'all_review_screen.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final reviewController = ReviewController.instance;

    return Column(
      children: [
        Sectionheading(
          title: 'Rating and Reviews',
          showActionButton: true,
          isPadding: true,
          isHeader: true,
          widgetActionButton: SizedBox(
            width: THelperFunctions.screenWidth(context) * 0.3,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              onPressed: () => Get.to(
                () => AddReviewScreen(productId: productId),
              ),
              child: Text('Add Review'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: reviewController.streamRatingSummary(productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text('Error loading reviews.'));
                  }

                  final ratingSummary = snapshot.data!;
                  final double averageRating =
                      ratingSummary['averageRating'] ?? 0.0;
                  final int totalReviews = ratingSummary['totalReviews'] ?? 0;
                  final Map<int, int> ratingDistribution =
                      ratingSummary['ratingDistribution'] ?? {};

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Overall Product Rating
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  averageRating.toStringAsFixed(
                                      1), // Show average rating
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBarIndicator(
                                      itemBuilder: (_, __) => const Icon(
                                        Iconsax.star1,
                                        color: TColors.primary,
                                      ),
                                      itemSize: 15,
                                      rating: averageRating,
                                    ),
                                    Text(
                                      ' (${totalReviews.toString()})', // Show total number of reviews
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: List.generate(5, (index) {
                                int starCount = 5 - index;
                                double ratingPercentage =
                                    ratingDistribution[starCount] != null &&
                                            totalReviews > 0
                                        ? ratingDistribution[starCount]! /
                                            totalReviews
                                        : 0.0;

                                return RatingProgressIndicator(
                                  text: starCount.toString(),
                                  value: ratingPercentage,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      StreamBuilder(
                        stream:
                            reviewController.streamProductReviews(productId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading reviews'));
                          }

                          final reviews = snapshot.data ?? [];

                          if (reviews.isEmpty) {
                            return const Center(
                                child: Text(
                                    'No reviews yet. Be the First to Add.'));
                          }

                          final limitedReviews = reviews.length > 5
                              ? reviews.take(5).toList()
                              : reviews;

                          return Column(
                            children: [
                              ...limitedReviews
                                  .map((review) => UserReviewCard(
                                        username: review.username,
                                        rating: review.rating,
                                        reviewText: review.reviewText,
                                        date: review.timestamp,
                                        title: review.title,
                                      ))
                                  .toList(),
                              if (reviews.length > 5)
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(
                                        () => AllReviewsScreen(
                                            productId: productId),
                                      );
                                    },
                                    child: Text(
                                      'See All ${reviews.length} Reviews ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: Colors.blueAccent),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
