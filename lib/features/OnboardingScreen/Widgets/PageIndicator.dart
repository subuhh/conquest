import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/Controllers/Onboarding_Controller/OnboardingController.dart';
import '../../../utils/constants/colors.dart';

Widget buildPageIndicator(OnboardingController? controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: SmoothPageIndicator(

      controller: controller!.pageController, // Safely access controller here
      count: 3,
      effect: ExpandingDotsEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: TColors.primary,
      ),
    ),
  );
}

