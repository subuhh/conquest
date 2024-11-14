import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquest/core/model/address.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:get/get.dart';
import '../model/banner.dart';
import '../model/Product_Models/product.dart';
import '../model/user.dart';

class FirestoreService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  // Reactive variables
  var userModel = Rxn<UserModel>();
  var categories = <Map<String, dynamic>>[].obs;
  var banners = <BannerModel>[].obs;
  var products = <ProductModel>[].obs;
  var addresses = <AddressModel>[].obs;
  var isLoading = false.obs;

  // --- User ---

  // Creating user document for storing data in Firestore
  Future<void> createUserDocument(UserModel user) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log('Error creating user document: $e');
      Get.snackbar('Error', 'Could not create user document');
    }
  }

  // Fetch User Details
  Future<UserModel?> getUserDetails(String? uid) async {
    try {
      isLoading.value = true;
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      UserModel? fetchedUserModel;
      if (snapshot.exists) {
        fetchedUserModel = UserModel.fromFirestore(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
        userModel.value = fetchedUserModel;
      } else {
        userModel.value = null; // User document not found
      }
      isLoading.value = false;
      return fetchedUserModel;
    } catch (e) {
      isLoading.value = false;
      log('Error getting user details: $e');
      Get.snackbar('Error', 'Could not fetch user details');
      return null;
    }
  }

  // Update User Details
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      log("Updating user with data: ${updatedUser.toMap()}");
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(updatedUser.userName)
          .update(updatedUser.toMap());
      log("Firestore update successful.");
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log('Error updating user details: $e');
      Get.snackbar('Error', 'Could not update user details');
      rethrow;
    }
  }

  // Check user document existence
  Future<bool> checkUserDocumentExists(String userId) async {
    try {
      isLoading.value = true;
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      isLoading.value = false;
      return snapshot.exists;
    } catch (e) {
      isLoading.value = false;
      log('Error checking user document: $e');
      Get.snackbar('Error', 'Could not check user document existence');
      return false;
    }
  }

  Future<bool> checkUserEmailExists(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Check Username Availability
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore
          .collection('users')
          .where('userName', isEqualTo: username)
          .get();
      isLoading.value = false;
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      isLoading.value = false;
      log('Error checking username availability: $e');
      Get.snackbar('Error', 'Could not check username availability');
      return false;
    }
  }

  // --- Category ---

  // Fetch all Categories from Firestore
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('category').get();
      final categoriesList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'image': doc['image'],
        };
      }).toList();
      isLoading.value = false;
      return categoriesList;
    } catch (e) {
      isLoading.value = false;
      log('Error fetching categories: $e');
      Get.snackbar('Error', 'Could not fetch categories');
      return []; // Return an empty list or handle error case as needed
    }
  }

  // --- Banners ---

  // Fetching targeted Banners
  Future<List<BannerModel>> fetchBanners({required String targetScreen}) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('banner')
          .where('targetScreen', isEqualTo: targetScreen)
          .where('active', isEqualTo: true)
          .get();
      log('Banner snapshot size: ${snapshot.size}');
      final bannersList = snapshot.docs
          .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
          .toList();
      isLoading.value = false;
      return bannersList;
    } catch (e) {
      isLoading.value = false;
      log('Error fetching banners: $e');
      Get.snackbar('Error', 'Could not fetch banners');
      return []; // Return an empty list or handle error case as needed
    }
  }

  // --- Address ---

  // To fetch all address
  Future<List<AddressModel>> fetchAllAddress(String userId) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();
      final fetchedAddress = snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc.data()))
          .toList();
      addresses.value = fetchedAddress;
      isLoading.value = false;
      return fetchedAddress;
    } catch (e) {
      isLoading.value = false;
      log('Error Fetching address: $e');
      Get.snackbar('Error', 'Could not fetch products');
      rethrow;
    }
  }

  // Stream to fetch all address
  Stream<QuerySnapshot> getAddressStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .snapshots();
  }

  // To store user address in address sub-collection
  Future<void> addAddress(AddressModel address) async {
    try {
      // Get current user's ID
      final user = _authService.user;
      final userData = await user.first;
      if (userData != null) {
        String userId = userData.uid;

        // Generate a new document ID for the address
        DocumentReference addressRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .doc();

        // Add the address to Firestore
        await addressRef.set({
          ...address.toMap(),
          'id': addressRef.id,
        });

        log('Address successfully added!');
      }
    } catch (e) {
      log('Error adding address: $e');
    }
  }

  // Check if user has any addresses saved
  Future<bool> isFirstAddress(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      throw Exception("Failed to check if it's the first address: $e");
    }
  }

  // Update the default address for the user
  Future<void> updateDefaultAddress(String userId, String addressId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'defaultAddressId': addressId,
      });
    } catch (e) {
      throw Exception("Failed to update default address: $e");
    }
  }

  // Delete Address from user
  Future<void> deleteAddress(String userId, String addressId) async {
    if (userId.isEmpty) {
      log('Error: UserId is empty.');
      throw Exception("Invalid userId ");
    }
    if (addressId.isEmpty) {
      log('Error: AddressId is empty.');
      throw Exception("Invalid addressId");
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();

      log('Address Deleted successfully!');
    } catch (e) {
      throw Exception("Failed to delete address: $e");
    }
  }
}
