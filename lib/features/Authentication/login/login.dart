import 'package:conquest/common/styles/spacing_styles.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/form_divider.dart';
import '../../../common/widgets/social_buttons.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/helpers/helper_functions.dart';
import 'login_form.dart';
import 'login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///Logo, Title & Sub-Title
              loginHeader(dark: dark),

              /// Form
              const LoginForm(),

              /// Divider
              const FormDivider(divierText: TTexts.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Footer
              const SocialButton()
            ],
          ),
        ),
      ),
    );
  }
}
