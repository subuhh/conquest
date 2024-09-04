import 'package:conquest/features/Authentication/first_time_login_by_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../features/utils/constants/colors.dart';
import '../../features/utils/constants/image_strings.dart';
import '../../features/utils/constants/sizes.dart';
import 'custom_snackbar.dart';

class SocialButton extends StatefulWidget {
  const SocialButton({
    super.key,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: TColors.grey,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: _handleGoogleSignIn,
            icon: const Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(TImages.google),
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: TColors.grey,
              ),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(TImages.facebook),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final result = await AuthService().signInWithGoogle(context);

    if (result != null) {
      final user = result['user'] as User?;
      final isDocumentExist = result['isDocumentExist'] as bool?;

      if (user != null) {
        if (isDocumentExist != null && isDocumentExist) {
          // User document exists, navigate to the homepage
          Navigator.pushNamedAndRemoveUntil(
              context, '/btmnav', (route) => false);
        } else {
          // User document does not exist, navigate to the info entry screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FirstTimeLogin(user: user),
            ), // Replace with your info entry screen
          );
        }
      }
    } else {
      // Handle sign-in failure (e.g., show an error message)
      showSnackBar(context, 'Failed to sign in with Google. Please try again.',
          isError: true);
    }
  }
}
