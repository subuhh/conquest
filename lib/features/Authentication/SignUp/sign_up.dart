import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/form_divider.dart';
import '../../../common/widgets/social_buttons.dart';
import '../../../core/Controllers/Authentication_Controller/signup_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Title
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Full Name field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      controller: controller.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Full Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Username field
                    TextFormField(
                      controller: controller.userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Username';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                          return 'Only alphabets, numbers, and underscores are allowed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Email field
                    TextFormField(
                      controller: controller.emailController,
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
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Phone Number field
                    TextFormField(
                      controller: controller.phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone no.',
                        prefixIcon: Icon(Iconsax.call),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Phone Number';
                        } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                          return 'Please enter a valid Phone Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Password field
                    Obx(() {
                      return TextFormField(
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: controller.obscureText.value
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              controller.obscureText.toggle();
                            },
                          ),
                        ),
                        obscureText: controller.obscureText.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 7) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!value.contains(RegExp(r'\d'))) {
                            return 'Password must contain at least one digit';
                          }
                          if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Terms & Conditions Checkbox
                    Obx(() {
                      return Row(
                        children: [
                          Checkbox(
                            value: controller.isChecked.value,
                            onChanged: (value) {
                              controller.isChecked.value = value!;
                            },
                          ),
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: '${TTexts.iAgreeTo} ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: '${TTexts.privacyPolicy} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: TColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: TColors.primary),
                              ),
                              TextSpan(
                                text: '${TTexts.and} ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: '${TTexts.termsOfUse} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: TColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: TColors.primary),
                              ),
                            ],
                          )),
                        ],
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Sign-up Button
                    Obx(() {
                      return SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: controller.isChecked.value
                              ? () => controller.signUp()
                              : null,
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(TTexts.createAccount),
                        ),
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Divider and Social Buttons
                    const FormDivider(divierText: TTexts.orSignUpWith),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    const SocialButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
