import 'package:conquest/common/widgets/form_divider.dart';
import 'package:conquest/common/widgets/social_buttons.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/enums.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              Text(TTexts.signupTitle, style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Form
              Form(child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Full Name', prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields,),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'UserName',
                        prefixIcon: Icon(Iconsax.user_edit)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields,),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Email', prefixIcon: Icon(Iconsax.direct)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields,),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Phone no.', prefixIcon: Icon(Iconsax.call)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields,),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password.',
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields,),

                  ///Term & Condition CheckBox
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Text.rich(TextSpan(
                          children: [
                            TextSpan(text: '${TTexts.iAgreeTo} ',style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: '${TTexts.privacyPolicy} ',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.primary, decoration: TextDecoration.underline,decorationColor: TColors.primary)),
                            TextSpan(text: '${TTexts.and} ',style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: '${TTexts.termsOfUse} ',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.primary, decoration: TextDecoration.underline,decorationColor: TColors.primary)),
                          ]
                      ))

                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections,),
                  ///Sign up button
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text(TTexts.createAccount))),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  ///Divider
                  FormDivider(divierText: TTexts.orSignUpWith),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  ///Social Button
                  const socialButton()
                ],
              ))

            ],
          ),
        ),
      ),
    );
  }
}
