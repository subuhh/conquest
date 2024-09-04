import 'dart:developer';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/services/auth_service.dart';
import '../../common/widgets/custom_snackbar.dart';
import '../../core/model/user.dart';

class FirstTimeLogin extends StatefulWidget {
  final User? user;
  const FirstTimeLogin({super.key, required this.user});

  @override
  State<FirstTimeLogin> createState() => _FirstTimeLoginState();
}

class _FirstTimeLoginState extends State<FirstTimeLogin> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isChecked = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _nameController.dispose();
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
                          onPressed: _isChecked ? _handleSignUp : () {},
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
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_formKey.currentState!.validate()) {
        // Check if username is available
        bool isUsernameAvailable = await FirestoreService()
            .checkUsernameAvailability(_userNameController.text);

        log('isAvaiable: $isUsernameAvailable');

        if (isUsernameAvailable) {
          final userModel = UserModel(
            id: widget.user!.uid,
            userName:
                _userNameController.text, // Use the username as the user ID
            name: _nameController.text,
            email: _auth.currentUser!.email!,
            phoneNumber: _phoneController.text,
          );

          await FirestoreService().createUserDocument(userModel);

          // Navigate to homepage
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/btmnav',
            (route) => false,
          );

        } else {
          // Show a message if username is not available
          showSnackBar(
              context, 'Username is already taken. Please choose another one.',
              isError: true);
        }
      }
    } catch (e) {
      // Handle error
      showSnackBar(context, 'Something went wrong. Please try again.',
          isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
