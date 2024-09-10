import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:conquest/core/services/auth_service.dart';
import '../../../common/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var obscureText = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  Future<void> logIn() async {
    isLoading.value = true;
    try {
      if (GetUtils.isEmail(emailController.text) && passwordController.text.isNotEmpty) {
        final userCredential = await _authService.loginWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
        if (userCredential != null) {
          Get.offAllNamed('/btmnav');
        }
      } else {
        showSnackBar('Error', 'Please enter valid email and password', isError: true);
      }
    } catch (e) {
      showSnackBar('Error', 'Something error occurred. Please try again', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
