import 'dart:developer';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/common/widgets/water_intake/water_intake_calculate.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/calorie_count/calorie_count.dart';
import '../Form_Controller/FormController.dart';

class FirstTimeLoginController extends GetxController
    with WidgetsBindingObserver {
  FirstTimeLoginController();

  final controller = FormController.instance;

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var isLoading = false.obs;
  var isChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    nameController =
        TextEditingController(text: controller.googleUser!.displayName);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    userNameController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      logoutUser();
    }
  }

  Future<bool> onWillPop() async {
    logoutUser();
    return true;
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> handleSignUp() async {
    isLoading.value = true;

    try {
      if (formKey.currentState!.validate()) {
        // Check username availability
        bool isUsernameAvailable;
        try {
          isUsernameAvailable = await FirestoreService()
              .checkUsernameAvailability(userNameController.text);
        } catch (e) {
          showSnackBar(
            'Error',
            'Failed to check username availability. Please try again.',
            isError: true,
          );
          log('Username check error: $e');
          return;
        }

        log('isAvailable: $isUsernameAvailable');

        if (isUsernameAvailable) {
          final User? user;

          double convertHeightToCm() {
            int feet = controller.selectedFeet.value;
            int inches = controller.selectedInches.value;
            return (feet * 30.48) + (inches * 2.54);
          }

          double convertWeightToDouble(
              int weightInteger, int weightFraction, String unit) {
            double weightInKg = weightInteger + (weightFraction / 10.0);

            if (unit == 'Lbs') {
              return weightInKg * 2.20462;
            }

            return weightInKg;
          }

          final calorie = CalorieCalculator.calculateCalorieRequirement(
            age: controller.selectedAge.value,
            gender: controller.selectedGender.value,
            heightCm: convertHeightToCm(),
            weightKg: convertWeightToDouble(
                controller.currentWeightInteger.value,
                controller.currentWeightFraction.value,
                controller.currentWeightUnit.value),
            activityLevel: controller.selectedWorkoutFrequency.value,
            goals: controller.selectedGoals,
          );

          final macros = CalorieCalculator.calculateMacros(
              calorie, controller.selectedGoals[0]);

          final waterGoal = WaterIntakeCalCul().calculateWaterIntakeGoal(
            convertWeightToDouble(
                controller.currentWeightInteger.value,
                controller.currentWeightFraction.value,
                controller.currentWeightUnit.value),
            controller.selectedWorkoutFrequency.value,
          );

          // Complete Firebase sign-in after form submission
          try {
            user = await AuthService()
                .completeFirebaseSignIn(controller.googleUser!);
          } catch (e) {
            showSnackBar(
              'Error',
              'Failed to complete sign-in. Please try again.',
              isError: true,
            );
            log('Sign-in completion error: $e');
            return;
          }

          final userModel = UserModel(
            id: user!.uid,
            userName: userNameController.text,
            name: nameController.text,
            email: user.email!,
            phoneNumber: phoneController.text,
            fitnessGoal: controller.selectedGoals,
            gender: controller.selectedGender.value,
            height: convertHeightToCm(),
            weight: convertWeightToDouble(
                controller.currentWeightInteger.value,
                controller.currentWeightFraction.value,
                controller.currentWeightUnit.value),
            weightGoal: convertWeightToDouble(
                controller.goalWeightInteger.value,
                controller.goalWeightFraction.value,
                controller.goalWeightUnit.value),
            workoutFrequency: controller.selectedWorkoutFrequency.value,
            dietPreference: controller.selectedDietPreferences,
            age: controller.selectedAge.value,
            profileImageUrl: user.photoURL ?? '',
            calorieGoal: calorie,
            waterGoal: WaterGoal(amount: waterGoal, unit: 'L'),
            proteinGoal: macros['protein'],
            carbsGoal: macros['carbs'],
            fatGoal: macros['fat'],
            fiberGoal: macros['fiber'],
            accountCreationTime: DateTime.now(),
          );

          // Create user document
          try {
            await FirestoreService().createUserDocument(userModel);
            Get.offAllNamed('/btmnav');
          } catch (e) {
            showSnackBar(
              'Error',
              'Failed to create user profile. Please try again.',
              isError: true,
            );
            log('Document creation error: $e');
            return;
          }
        } else {
          showSnackBar(
            'Error',
            'Username is already taken. Please choose another one.',
            isError: true,
          );
        }
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Something went wrong. Please try again.',
        isError: true,
      );
      log('General error in handleSignUp: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
