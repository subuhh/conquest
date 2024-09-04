import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/widgets/custom_snackbar.dart';
import '../model/user.dart';
import 'firestore_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  User? _userFromFirebaseUser(User? user) {
    return user;
  }

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // User Current Status
  User? get currentUser {
    return _auth.currentUser;
  }

  // Register user with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String name,
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      // Check if the username is available
      bool isUsernameAvailable =
          await FirestoreService().checkUsernameAvailability(username);

      if (!isUsernameAvailable) {
        showSnackBar(
            context, 'Username is already taken. Please choose another one.',
            isError: true);
        return null;
      }

      // If the username is available, proceed with registration
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      notifyListeners();

      if (user != null) {
        // Create UserModel object with username as the userId and add to Firestore
        final userModel = UserModel(
          id: user.uid,
          userName: username, // Use the username as the user ID
          name: name,
          email: email,
          phoneNumber: phoneNumber,
        );

        // Save user data in Firestore
        await FirestoreService().createUserDocument(userModel);

        return _userFromFirebaseUser(user);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The email is already in use.', isError: true);
      } else {
        showSnackBar(
            context, 'An error occurred during registration. Please try again.',
            isError: true);
      }
    } catch (error) {
      log('Error registering: $error'); // Debug statement
      showSnackBar(context, 'An unexpected error occurred. Please try again.',
          isError: true);
      return null;
    }
    return null;
  }

  // Login with email and password
  Future<UserCredential?> loginWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code}');
      if (e.code == 'invalid-credential') {
        showSnackBar(context, 'Invalid Email or Password.', isError: true);
      } else if (e.code == 'too-many-requests') {
        showSnackBar(
            context, 'Too many login attempts. Please try again later.',
            isError: true);
      } else {
        showSnackBar(
            context, 'An error occurred during login. Please try again.',
            isError: true);
      }
      return null;
    } catch (e) {
      // Handle other potential errors
      log('Error logging in with email and password: $e');
      showSnackBar(context, 'An unexpected error occurred. Please try again.',
          isError: true);
      return null;
    }
  }

  // sign in the user with google
  Future<Map<String, dynamic>?> signInWithGoogle(BuildContext context) async {
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
    } catch (error) {
      log('Error sending password reset email: $error'); // Debug statement
      rethrow;
    }
  }

  // check which Signed-In method
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
    return null; // User is not signed in
  }

  // Signed with email & password ?
  bool isSignedInWithEmailAndPassword() {
    String? signInMethod = getSignInMethod();
    return signInMethod == 'email';
  }

  // Signed with google ?
  bool isSignedInWithGoogle() {
    String? signInMethod = getSignInMethod();
    return signInMethod == 'google';
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners(); // Notify listeners about the change
    } catch (error) {
      log('Error signing out: $error'); // Debug statement
    }
  }
}
