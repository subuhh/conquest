import 'dart:developer';
import 'package:get/get.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/firestore_service.dart';

class DrawerMenuController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  var isLoading = true.obs;
  var userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final user = _authService.user;
    try {
      final userData = await user.first;
      if (userData != null) {
        final userDetails = await _firestoreService.getUserDetails(userData.uid);
        userModel.value = userDetails;
      }
    } catch (e) {
      log('Error fetching user details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
