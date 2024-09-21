import 'dart:developer';
import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/common/widgets/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/Product_Controller/review_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController();
    final review = TextEditingController();
    double ratings = 0.0;
    final reviewController = ReviewController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: TSizes.defaultSpace),
            Center(
              child: RatingBar.builder(
                initialRating: ratings,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  ratings = rating;
                  log('Ratings: $ratings');
                },
                minRating: 1,
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            SectionDivider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Sectionheading(
                    title: 'Add title ',
                    isHeader: true,
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: TColors.secondaryBackground,
                      hintText: 'Please write your title here',
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  Sectionheading(
                    title: 'Write your review here ',
                    isHeader: true,
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  TextFormField(
                    controller: review,
                    keyboardType: TextInputType.multiline,
                    maxLength: 500,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: TColors.secondaryBackground,
                      hintText: 'Please write your review here',
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                reviewController.addReview(
                  productId,
                  title.text.trim(),
                  review.text.trim(),
                  ratings,
                  reviewController.userModel.value!.userName,
                  reviewController.userModel.value!.id,
                );
                Get.back();
              }
            },
            child: reviewController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1,
                    ),
                  )
                : Text('SUBMIT'),
          ),
        ),
      ),
    );
  }
}
