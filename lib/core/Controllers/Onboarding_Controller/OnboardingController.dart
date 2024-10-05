// onboarding_controller.dart

import 'package:flutter/material.dart';

class OnboardingController {
  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index, Function(int) updatePageState) {
    currentPage = index;
    updatePageState(currentPage);
  }

  void nextPage(Function updatePageState) {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Do nothing, or handle completion if needed
    }
  }

  void skipToLast() {
    pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void dispose() {
    pageController.dispose();
  }
}
