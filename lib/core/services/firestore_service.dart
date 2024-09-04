import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- User ---

  // Creating user document for storing data in fire
  Future<void> createUserDocument(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      log('Error creating user document: $e');
    }
  }

  // User Details Fetch From Firebase
  Future<UserModel?> getUserDetails(String? uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromFirestore(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return null; // User document not found
      }
    } catch (e) {
      log('Error getting user details: $e');
      return null;
    }
  }

  // Update User Details
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      log("Updating user with data: ${updatedUser.toMap()}");
      await _firestore
          .collection('users')
          .doc(updatedUser.userName) // Assuming you have the user ID
          .update(updatedUser.toMap());
      log("Firestore update successful.");
    } catch (e) {
      log('Error updating user details: $e');
      rethrow; // Re-throw the error to be handled in the UI
    }
  }

  // Check user document exists or not
  Future<bool> checkUserDocumentExists(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(userId).get();
    return snapshot.exists;
    // Return true if the document exists, false otherwise
  }

  // check UserName Exists or Not
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      // Query the users collection where the userName field matches the given username
      final querySnapshot = await _firestore
          .collection('users')
          .where('userName', isEqualTo: username)
          .get();

      // If the query returns any documents, the username is not available
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      log('Error checking username availability: $e');
      // Handle any errors (e.g., network issues)
      return false;
    }
  }
}
