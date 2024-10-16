import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../common/widgets/custom_snackbar.dart';

class SignUpController extends GetxController {
  final AuthService _auth = AuthService();

  // Controllers for text fields
  final userNameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // State management
  RxBool isLoading = false.obs;
  RxBool obscureText = true.obs;
  RxBool isChecked = false.obs;

  // Dispose text controllers when done
  @override
  void onClose() {
    userNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Sign-up function
  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      if (!isChecked.value) {
        showSnackBar('Error', 'Please agree to the terms and conditions.',
            isError: true);
        return;
      }

      try {
        final userCredential = await _auth.registerWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          userNameController.text,
          nameController.text,
          phoneController.text,
        );

        if (userCredential != null) {
          Get.offAllNamed('/btmnav');
        } else {
          showSnackBar('Error', 'Something went wrong. Please try again.',
              isError: true);
        }
      } catch (e) {
        showSnackBar('Error', 'Something went wrong. Please try again.',
            isError: true);
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Future<void> _
}
