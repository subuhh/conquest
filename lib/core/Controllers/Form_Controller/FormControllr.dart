import 'package:conquest/features/Form/Widgets/howMuchWorkout.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../features/Form/Widgets/GoalQuestion.dart';
import '../../../features/Form/Widgets/HeightPIcker.dart';
import '../../../features/Form/Widgets/WeightQuestion.dart';
import '../../../features/Form/Widgets/foodcategoryGrid.dart';

class FormController extends GetxController {
  // Questions and corresponding SVG images
  final List<String> questions = [
    "What is your Goal?",
    "What is your Height?",
    "How much do you weight?",
    "What is you Goal Weight",
    "How often do you workout",
    "Select your Diet Preferences",
  ];

  final List<String> pictures = [
    'assets/images/AnimeQuestion1.png',
    'assets/images/AnimeQuestion2.png',
    'assets/images/AnimeQuestion3.png',
    'assets/images/AnimeQuestionGoalWeight.png',
    'assets/images/AnimeQuestionHowMunchWorkout.png',
    'assets/images/AnimeQuestion4.png',
  ];

  // Observable state
  RxInt currentQuestionIndex = 0.obs;

  // Getter for current question and image
  String get currentQuestion => questions[currentQuestionIndex.value];
  String get currentPicture => pictures[currentQuestionIndex.value];

  // Progress calculation
  double get progress => (currentQuestionIndex.value + 1) / questions.length;

  // Navigate to next question
  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex++;
    }
  }

  // Navigate to previous question
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex--;
    } else {
      Get.back();
    }
  }

  // Dynamic widget corresponding to each question
  Widget get currentWidget {
    switch (currentQuestionIndex.value) {
      case 0:
        return GoalQuestion(controller: this);
      case 1:
        return HeightPickerScreen(controller: this);

      case 2:
        return  WeightPickerScreen(controller: this);

      case 3:
        return WeightPickerScreen(controller: this);

      case 4:
        return Howmuchworkout();

      case 5:
        return FoodCategoryGrid();
      default:
        return Container(); // Fallback
    }
  }
}
