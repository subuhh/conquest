import 'package:conquest/common/widgets/form_divider.dart';
import 'package:conquest/common/widgets/social_buttons.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_snackbar.dart';
import '../../../core/services/auth_service.dart';
import '../login/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _isChecked = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Title
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Form
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextFormField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'UserName',
                          prefixIcon: Icon(Iconsax.user_edit),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Username';
                          }
                          // Validate for allowed characters
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                            return 'Only alphabets, numbers, and underscores are allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Iconsax.direct),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email.';
                          }
                          final emailRegExp = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          // Temporary email domain validation
                          final tempEmailDomains = [
                            'mailinator.com',
                            'tempmail.com',
                            '10minutemail.com',
                            // Add more temporary email domains as needed
                          ];
                          final domain =
                              value.split('@')[1]; // Extract the domain part
                          if (tempEmailDomains.contains(domain)) {
                            return 'Temporary email addresses are not allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone no.',
                          prefixIcon: Icon(Iconsax.call),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Phone Number'; // Allows empty input
                          } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                            return 'Please enter a valid Phone Number';
                          }
                          return null; // Valid input
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password.',
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: _obscureText
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          if (value.length < 7) {
                            return 'Password must be at least 8 character';
                          }

                          // Check for at least one uppercase letter
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one uppercase letter';
                          }

                          // Check for at least one lowercase letter
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Password must contain at least one lowercase letter';
                          }

                          // Check for at least one digit
                          if (!value.contains(RegExp(r'\d'))) {
                            return 'Password must contain at least one digit';
                          }

                          // Check for at least one special character
                          if (!value
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            // Customize the special characters allowed
                            return 'Password must contain at least one special character';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      ///Term & Condition CheckBox
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: '${TTexts.iAgreeTo} ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: '${TTexts.privacyPolicy} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                        color: TColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: TColors.primary)),
                            TextSpan(
                                text: '${TTexts.and} ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: '${TTexts.termsOfUse} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                        color: TColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: TColors.primary)),
                          ]))
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      ///Sign up button
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: _isChecked ? _signUp : () {},
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  TTexts.createAccount,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),

                      ///Divider
                      const FormDivider(divierText: TTexts.orSignUpWith),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      ///Social Button
                      const SocialButton()
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      if (_formKey.currentState!.validate()) {
        final userCredential = await _auth.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _userNameController.text,
          _nameController.text,
          _phoneController.text,
        );
        if (userCredential != null) {
          Get.off(const LoginScreen());
          showSnackBar('Error', 'Account created successfully. Please log in.');
        }
      }
    } catch (e) {
      showSnackBar('Error', 'Something error occurred. Please try again',
          isError: true);
      setState(() => _isLoading = false);
    } finally {
      setState(() => _isLoading = false);
    }
    setState(() => _isLoading = false);
  }
}
