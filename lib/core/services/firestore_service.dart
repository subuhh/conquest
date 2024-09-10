import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/banner.dart';
import '../model/product.dart';
import '../model/user.dart';

class FirestoreService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  var userModel = Rxn<UserModel>();
  var categories = <Map<String, dynamic>>[].obs;
  var banners = <BannerModel>[].obs;
  var products = <ProductModel>[].obs;
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

  // --- Products ---

  // Fetching all Products
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('products').get();
      log('Products snapshot size: ${snapshot.size}');
      final fetchedProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data()))
          .toList();
      products.value = fetchedProducts;
      isLoading.value = false;
      return fetchedProducts;
    } catch (e) {
      isLoading.value = false;
      log('Error fetching the products: $e');
      Get.snackbar('Error', 'Could not fetch products');
      rethrow;
    }
  }
}
