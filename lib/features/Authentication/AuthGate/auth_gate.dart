import 'package:conquest/features/OnboardingScreen/ONboardingScreen.dart';
import 'package:conquest/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Controllers/user_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../BottomNavBar/bottom_nav_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService.instance;

    return Obx(() {
      if (authService.currentUser == null) {
        return OnboardingScreen(); // Show onboarding screen if not signed in
      } else {
        TLocalStorage.init(authService.currentUser!.uid);
        Get.put(UserController());
        return const BottomNavBar(); // Show login if not admin
      }
    });
  }
}
