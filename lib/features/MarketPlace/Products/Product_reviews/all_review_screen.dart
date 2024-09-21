import 'package:conquest/core/Controllers/Product_Controller/review_controller.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/UserReviewCard.dart';
import 'package:conquest/features/MarketPlace/Products/Product_reviews/rating_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final reviewController = ReviewController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: Padding(
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
                  return const Center(
                      child: Text('Error loading rating summary.'));
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
                                averageRating
                                    .toStringAsFixed(1), // Show average rating
                                style: Theme.of(context).textTheme.displayLarge,
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
                  ],
                );
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: reviewController.streamProductReviews(productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading reviews'));
                  }

                  final reviews = snapshot.data ?? [];

                  if (reviews.isEmpty) {
                    return const Center(
                        child: Text('No reviews yet. Be the First to Add.'));
                  }

                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return UserReviewCard(
                        username: review.username,
                        rating: review.rating,
                        reviewText: review.reviewText,
                        date: review.timestamp,
                        title: review.title,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
