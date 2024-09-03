import 'package:conquest/features/Authentication/SignUp/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';


class loginForm extends StatelessWidget {
  const loginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              /// Email
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),

              /// Pasword
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: TTexts.password,
                  suffixIcon: Icon(Iconsax.eye_slash),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),

              /// Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Remember me
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const Text(TTexts.rememberMe),
                    ],
                  ),

                  ///ForgetPassword
                  TextButton(
                      onPressed: null, child: Text(TTexts.forgetPassword))
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              /// Sized Box
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () {}, child: Text(TTexts.signIn))),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              ///Create Account Button

              SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                    },
                     // onPressed: ()=> Get.to(()=>const SignUpScreen()),
                      child: Text(TTexts.createAccount)))
            ],
          ),
        ));
  }
}


