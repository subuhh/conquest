import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';

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
            onPressed: () async {
              await AuthService().handleUserGoogleSignIn();
            },
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

  // Future<void> _handleGoogleSignIn() async {
  //   final result = await AuthService().signInWithGoogle();
  //
  //   // if (result != null) {
  //   //   final user = result['user'] as User?;
  //   //   final isDocumentExist = result['isDocumentExist'] as bool?;
  //   //
  //   //   if (user != null) {
  //   //     if (isDocumentExist != null && isDocumentExist) {
  //   //       // User document exists, navigate to the homepage
  //   //       Get.offAllNamed('/btmnav');
  //   //     } else {
  //   //       // if (formController.selectedGender.value.isNotEmpty) {
  //   //       //   // All Field are done go with first time login
  //   //       // Get.off(() => FirstTimeLogin(user: user));
  //   //       // } else {
  //   //       AuthService().signOut();
  //   //       Get.to(() => FormScreen(isFromGoogle: true));
  //   //       // }
  //   //     }
  //   //   }
  //   // } else {
  //   //   // Handle sign-in failure (e.g., show an error message)
  //   //   showSnackBar('Error', 'Failed to sign in with Google. Please try again.',
  //   //       isError: true);
  //   // }
  // }
}
