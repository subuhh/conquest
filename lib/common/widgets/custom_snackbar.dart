import 'package:flutter/material.dart';

import '../../features/utils/constants/colors.dart';

void showSnackBar(
    BuildContext context,
    String message, {
      bool isError = false,
      bool isLoading = false,
      bool isDuration = false,
      bool isBehaviourFloat = true,
      Duration time = const Duration(days: 1),
    }) {
  final Color backgroundColor = isError ? Colors.red : TColors.primary;

  final snackBar = SnackBar(
    content: Row(
      children: [
        // Optional icon based on error or success
        isError
            ? const Icon(Icons.error_outline, color: Colors.white, size: 30)
            : const Icon(Icons.check_circle_outline,
            color: Colors.white, size: 30),
        const SizedBox(width: 10),
        Flexible(
          // Wrap text in Flexible to allow wrapping
          child: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior:
    // isBehaviourFloat ?
    SnackBarBehavior.floating,
    // SnackBarBehavior.fixed,
    margin: const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 20,
    ),
    duration: isDuration ? time : const Duration(seconds: 2),
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );

  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  if (scaffoldMessenger != null) {
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
