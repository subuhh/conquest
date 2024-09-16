import 'package:conquest/features/Authentication/ForgotPassword/forgot_password.dart';
import 'package:conquest/features/Authentication/SignUp/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../core/services/auth_service.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections,
          ),
          child: Column(
            children: [
              /// Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  }

                  final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegExp.hasMatch(value)) {
                    return 'Invalid email address.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: TTexts.password,
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
                    return 'Password is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),

              /// Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ///Remember me
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: true,
                  //       onChanged: (value) {},
                  //     ),
                  //     const Text(TTexts.rememberMe),
                  //   ],
                  // ),

                  ///ForgetPassword
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordResetScreen())),
                    child: const Text(TTexts.forgetPassword),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sized Box
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: _logIn,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          TTexts.signIn,
                        ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              ///Create Account Button
              SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  // onPressed: ()=> Get.to(()=>const SignUpScreen()),
                  child: const Text(
                    TTexts.createAccount,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _logIn() async {
    setState(() => _isLoading = true);
    try {
      if (_formKey.currentState!.validate()) {
        final userCredential = await _auth.loginWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (userCredential != null) {
          Get.offAllNamed('/btmnav');
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
