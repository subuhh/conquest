
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_snackbar.dart';
import '../../utils/constants/text_strings.dart';


class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  // final _auth = AuthService();
  bool _isLoading = false;
  // final FirestoreService _firestoreService = FirestoreService();

  Future<void> _sendResetPasswordEmail() async {
    try {
      setState(() => _isLoading = true);

      // 1. Check if email is empty
      // if (_emailController.text.isEmpty) {
      //   showSnackBar(context, 'Please enter your email address.');
      //   return; // Don't proceed if email is empty
      // }

      // 2. Check if email exists in Firestore
      // bool emailExists = await _firestoreService.checkEmailExists(
      //   _emailController.text,
      // );

      // if (!emailExists) {
      //   showSnackBar(context, 'Email not found.');
      //   return; // Don't proceed if email doesn't exist
      // }

      // 3. Send reset password email
      //await _auth.sendPasswordResetEmail(_emailController.text);

      // 4. Show success message after sending email
      Navigator.of(context).pop();
      showSnackBar(
        context,
        'Password reset email sent. Please check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      if (e.code == 'invalid-email') {
        showSnackBar(context, 'The email address is badly formatted.');
      } else if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found with that email.');
      } else {
        showSnackBar(context, 'An error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle other general errors
      showSnackBar(context, 'An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/LoginBackgeoundImage.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                alignment: Alignment.bottomLeft,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please enter your email address. A mail will be sent to your email to reset password',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: TTexts.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    // TextField(
                    //   controller: _emailController,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    //     hintText: 'abc@email.com',
                    //     hintStyle: Theme.of(context)
                    //         .textTheme
                    //         .bodyMedium
                    //         ?.copyWith(color: Colors.grey),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   style: const TextStyle(color: Colors.black),
                    //   keyboardType: TextInputType.emailAddress,
                    // ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendResetPasswordEmail,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: TColors.primary,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Send ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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