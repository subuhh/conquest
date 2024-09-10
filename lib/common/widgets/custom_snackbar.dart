import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/utils/constants/colors.dart';

void showSnackBar(
    String message, String title, {
      bool isError = false,
      bool isLoading = false,
      bool isDuration = false,
      bool isBehaviourFloat = true,
      Duration time = const Duration(days: 1),
    }) {
  final Color backgroundColor = isError ? Colors.red : TColors.primary;

  Get.snackbar(
    title,
    message,
    icon: isError
        ? const Icon(Icons.error_outline, color: Colors.white, size: 30)
        : const Icon(Icons.check_circle_outline, color: Colors.white, size: 30),
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
    borderRadius: 12.0,
    duration: isDuration ? time : const Duration(seconds: 2),
    isDismissible: true,
    snackStyle: isBehaviourFloat ? SnackStyle.FLOATING : SnackStyle.GROUNDED,
    animationDuration: const Duration(milliseconds: 300),
  );
}


