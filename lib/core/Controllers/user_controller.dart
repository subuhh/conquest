import 'dart:developer';

import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:get/get.dart';
import '../model/user.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final authService = AuthService.instance;
  final firestoreService = FirestoreService();

  var isLoading = true.obs;
  var userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = authService.currentUser;

      if (user != null) {
        UserModel? fetchedUserModel =
            await firestoreService.getUserDetails(user.uid);

        if (fetchedUserModel != null) {
          userModel.value = fetchedUserModel;
        }
      }
    } catch (e) {
      log("Failed to fetch user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
