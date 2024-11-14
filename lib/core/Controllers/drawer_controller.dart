import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/firestore_service.dart';

class DrawerMenuController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var isLoading = true.obs;
  var userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    log('Current User Id: $user');
    try {
      // if (userData != null) {
      final userDetails = await _firestoreService.getUserDetails(user);
      userModel.value = userDetails;
      // }
    } catch (e) {
      log('Error fetching user details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
