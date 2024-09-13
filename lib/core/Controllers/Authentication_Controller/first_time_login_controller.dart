import 'dart:developer';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          final userModel = UserModel(
            id: user!.uid,
            userName: userNameController.text,
            name: nameController.text,
            email: user!.email!,
            phoneNumber: phoneController.text,
          );

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
