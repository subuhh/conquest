import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/Controllers/Authentication_Controller/first_time_login_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class FirstTimeLogin extends StatelessWidget {
  const FirstTimeLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FirstTimeLoginController());

    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
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
                  key: controller.formKey,
                  child: Column(
                    children: [
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
                      TextFormField(
                        controller: controller.userNameController,
                        decoration: const InputDecoration(
                          labelText: 'UserName',
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

                      ///Term & Condition CheckBox
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.isChecked.value,
                                onChanged: (value) {
                                  controller.isChecked.value = value!;
                                },
                              )),
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
                      Obx(
                        () => SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: controller.isChecked.value
                                ? controller.handleSignUp
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isChecked.value
                                    ? TColors.primary
                                    : TColors.primary.withOpacity(0.5)),
                            child: controller.isLoading.value
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
