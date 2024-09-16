import 'package:conquest/features/Authentication/FirstTimeLogin/first_time_login_by_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
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
      ],
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final result = await AuthService().signInWithGoogle();

    if (result != null) {
      final user = result['user'] as User?;
      final isDocumentExist = result['isDocumentExist'] as bool?;

      if (user != null) {
        if (isDocumentExist != null && isDocumentExist) {
          // User document exists, navigate to the homepage
          Get.offAllNamed('/btmnav');
        } else {
          // User document does not exist, navigate to the info entry screen

          Get.off(() => FirstTimeLogin(user: user));
        }
      }
    } else {
      // Handle sign-in failure (e.g., show an error message)
      showSnackBar('Error', 'Failed to sign in with Google. Please try again.',
          isError: true);
    }
  }
}
