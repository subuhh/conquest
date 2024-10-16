import 'package:conquest/features/Authentication/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../Form/Form.dart';

Widget buildBottomNavigationBarButtons(context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => FormScreen());
          },
          child: Text('Create Account'),
        ),
      ),
      SizedBox(
        height: TSizes.spaceBtwItems / 2,
      ),
      TextButton(
        onPressed: () {
          Get.to(() => LoginScreen());
        },
        child: Text.rich(
          TextSpan(
            text: 'Already a member? ', // Regular text
            style: Theme.of(context)
                .textTheme
                .titleSmall!, // Apply your theme's text style
            children: [
              TextSpan(
                text: 'Sign In', // The part you want bold
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold, // Make this text bold
                      color: TColors.primary, // Ensure color matches
                    ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: TSizes.spaceBtwItems,
      ),
    ],
  );
}
