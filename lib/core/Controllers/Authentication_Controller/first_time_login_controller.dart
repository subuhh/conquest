import 'dart:developer';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Form_Controller/FormController.dart';

class FirstTimeLoginController extends GetxController with WidgetsBindingObserver {
  final User? user;

  FirstTimeLoginController(this.user);

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;
  var isChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
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
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
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
        bool isUsernameAvailable = await FirestoreService()
            .checkUsernameAvailability(userNameController.text);

        log('isAvaiable: $isUsernameAvailable');

        if (isUsernameAvailable) {

          final controller = FormController.instance;

          double convertHeightToCm() {
            int feet = controller.selectedFeet.value;
            int inches = controller.selectedInches.value;
            return (feet * 30.48) + (inches * 2.54);
          }

          double convertWeightToDouble(
              int weightInteger, int weightFraction, String unit) {
            // Combine integer and fractional weight
            double weightInKg = weightInteger + (weightFraction / 10.0);

            if (unit == 'Lbs') {
              // Convert lbs to kg (1 lb = 0.453592 kg)
              return weightInKg * 2.20462;
            }

            return weightInKg;
          }

          final userModel = UserModel(
            id: user!.uid,
            userName: userNameController.text,
            name: nameController.text,
            email: user!.email!,
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
            dietPreference: controller.selectedDietPreferences,          );

          await FirestoreService().createUserDocument(userModel);

          Get.offAllNamed('/btmnav');
        } else {
          showSnackBar('Error', 'Username is already taken. Please choose another one.', isError: true);
        }
      }
    } catch (e) {
      showSnackBar('Error', 'Something went wrong. Please try again.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
