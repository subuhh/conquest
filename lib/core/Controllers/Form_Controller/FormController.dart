import 'package:conquest/features/Form/Widgets/GoalWeight.dart';
import 'package:conquest/features/Form/Widgets/HowMuchWorkout.dart';
import 'package:conquest/features/Form/Widgets/age_question.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../features/Form/Widgets/GoalQuestion.dart';
import '../../../features/Form/Widgets/HowMuchHeight.dart';
import '../../../features/Form/Widgets/HowMuchWeight.dart';
import '../../../features/Form/Widgets/DietPreference.dart';

class FormController extends GetxController {
  static FormController get instance => Get.find();
  // Questions and corresponding SVG images
  final List<String> questions = [
    "What is your Goal?",
    "What is your Height?",
    "How much do you weight?",
    "What is you Goal Weight",
    "Select how often you engage in workout",
    "Select your Diet Preferences",
    "Enter your age",
  ];

  final List<String> pictures = [
    'assets/images/AnimeQuestion1.png',
    'assets/images/AnimeQuestion2.png',
    'assets/images/AnimeQuestion3.png',
    'assets/images/AnimeQuestionGoalWeight.png',
    'assets/images/AnimeQuestionHowMunchWorkout.png',
    'assets/images/AnimeQuestion4.png',
    'assets/images/age_male_bg.png',
  ];

  /// Observable state ///

  // Question Index
  RxInt currentQuestionIndex = 0.obs;
  // Goal Question
  RxList<String> selectedGoals = <String>[].obs;
  // Height Question
  RxInt selectedFeet = 5.obs;
  RxInt selectedInches = 7.obs;
  // Weight Question
  RxInt currentWeightInteger = 60.obs;
  RxInt currentWeightFraction = 5.obs;
  RxString currentWeightUnit = 'Kg'.obs;
  // Goal Weight Question
  RxInt goalWeightInteger = 60.obs;
  RxInt goalWeightFraction = 5.obs;
  RxString goalWeightUnit = 'Kg'.obs;
  // Workout Frequency Question
  RxString selectedWorkoutFrequency = ''.obs;
  // Diet Preference Question
  RxList<String> selectedDietPreferences = <String>[].obs;
  // Age
  RxInt selectedAge = 0.obs;
  // Gender
  RxString selectedGender = ''.obs;

  GoogleSignInAccount? googleUser;

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
        return GoalQuestion();
      case 1:
        return HeightPickerScreen();

      case 2:
        return HowMuchWeightScreen();

      case 3:
        return GoalWeightScreen();

      case 4:
        return HowMuchWorkout();

      case 5:
        return DietPreference();

      case 6:
        return AgeQuestion();

      default:
        return Container(); // Fallback
    }
  }
}
