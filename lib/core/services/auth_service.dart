import 'dart:developer';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/Controllers/Form_Controller/FormController.dart';
import 'package:conquest/core/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

class AuthService extends GetxController {
  static AuthService get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User?> firebaseUser = Rxn<User?>(); // Observable user state

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(
        _auth.authStateChanges()); // Bind Firebase auth stream to Rxn
  }

  // Current user
  User? get currentUser => firebaseUser.value;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Register user with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String name,
    String phoneNumber,
  ) async {
    try {
      // Check if the username is available
      bool isUsernameAvailable =
          await FirestoreService().checkUsernameAvailability(username);

      if (!isUsernameAvailable) {
        showSnackBar(
            'Error', 'Username is already taken. Please choose another one.');
        return null;
      }

      // If the username is available, proceed with registration
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      firebaseUser.value = user; // Update the user state

      if (user != null) {
        final controller = FormController.instance;

        double convertHeightToCm() {
          int feet = controller.selectedFeet.value;
          int inches = controller.selectedInches.value;
          return (feet * 30.48) + (inches * 2.54);
        }

        double convertWeightToDouble(
            int weightInteger, int weightFraction, String unit) {
          // Combine integer and fractional weight
          double weightInKg = weightInteger + (weightFraction / 10.0);

          if (unit == 'Lbs') {
            // Convert lbs to kg (1 lb = 0.453592 kg)
            return weightInKg * 2.20462;
          }

          return weightInKg;
        }

        final userModel = UserModel(
          id: user.uid,
          userName: username,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          fitnessGoal: controller.selectedGoals,
          gender: controller.selectedGender.value,
          height: convertHeightToCm(),
          weight: convertWeightToDouble(
              controller.currentWeightInteger.value,
              controller.currentWeightFraction.value,
              controller.currentWeightUnit.value),
          weightGoal: convertWeightToDouble(
              controller.goalWeightInteger.value,
              controller.goalWeightFraction.value,
              controller.goalWeightUnit.value),
          workoutFrequency: controller.selectedWorkoutFrequency.value,
          dietPreference: controller.selectedDietPreferences,
        );
        await FirestoreService().createUserDocument(userModel);
        return user;
      }

      return null;

      // return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar('Error', 'The email is already in use.');
      } else {
        showSnackBar('Error',
            'An error occurred during registration. Please try again.');
      }
      return null;
    } catch (error) {
      log('Error registering: $error');
      showSnackBar('Error', 'An unexpected error occurred. Please try again.');
      return null;
    }
  }

  // Login with email and password
  Future<UserCredential?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = userCredential.user;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code}');
      if (e.code == 'invalid-credential') {
        showSnackBar('Error', 'Invalid Email or Password.');
      } else if (e.code == 'user-not-found') {
        showSnackBar('Error', 'No user found with that email.');
      } else if (e.code == 'too-many-requests') {
        showSnackBar(
            'Error', 'Too many login attempts. Please try again later.');
      } else {
        showSnackBar(
            'Error', 'An error occurred during login. Please try again.');
      }
      return null;
    } catch (e) {
      log('Error logging in with email and password: $e');
      showSnackBar('Error', 'An unexpected error occurred. Please try again.');
      return null;
    }
  }

  // Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if user document exists in Firestore
        final isDocumentExist =
            await FirestoreService().checkUserDocumentExists(result.user!.uid);

        firebaseUser.value = result.user;

        // Return a map with the user and document existence status
        return {
          'user': result.user,
          'isDocumentExist': isDocumentExist,
        };
      } else {
        return null;
      }
    } catch (error) {
      log('Error signing in with Google: $error');
      return null;
    }
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code}');
      if (e.code == 'invalid-credential') {
        showSnackBar('Error', 'Invalid Email or Password.');
      } else if (e.code == 'user-not-found') {
        showSnackBar('Error', 'No user found with that email.');
      } else {
        showSnackBar('Error',
            'An error occurred during reset password. Please try again.');
      }
      return null;
    } catch (error) {
      log('Error sending password reset email: $error');
      rethrow;
    }
  }

  // Get sign-in method
  String? getSignInMethod() {
    final user = _auth.currentUser;
    if (user != null) {
      final providerData = user.providerData;
      for (var info in providerData) {
        if (info.providerId == 'password') {
          return 'email'; // User signed in with email/password
        } else if (info.providerId == 'google.com') {
          return 'google'; // User signed in with Google
        }
      }
    }
    return null;
  }

  // Check if signed in with email & password
  bool isSignedInWithEmailAndPassword() {
    return getSignInMethod() == 'email';
  }

  // Check if signed in with Google
  bool isSignedInWithGoogle() {
    return getSignInMethod() == 'google';
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      firebaseUser.value = null; // Reset the user
    } catch (error) {
      log('Error signing out: $error');
    }
  }
}
