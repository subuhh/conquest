import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import '../../../../../../core/model/user.dart';
import '../../../../../../core/services/auth_service.dart';
import '../../../../../../core/services/firestore_service.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final auth = Get.put(AuthService());

  var isLoading = true.obs;
  var isEdited = false.obs;
  var userModel = Rxn<UserModel>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController userNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  String? selectedGender;

  @override
  void onInit() {
    super.onInit();
    log('Fetch User Data Called');
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        UserModel? fetchedUserModel = await _firestoreService.getUserDetails(user.uid);
        if (fetchedUserModel != null) {
          userModel.value = fetchedUserModel;
          nameController = TextEditingController(text: fetchedUserModel.name)
            ..addListener(_checkIfEdited);
          userNameController = TextEditingController(text: fetchedUserModel.userName)
            ..addListener(_checkIfEdited);
          emailController = TextEditingController(text: fetchedUserModel.email)
            ..addListener(_checkIfEdited);
          phoneController = TextEditingController(text: fetchedUserModel.phoneNumber)
            ..addListener(_checkIfEdited);
          bioController = TextEditingController(text: fetchedUserModel.bio)
            ..addListener(_checkIfEdited);
          selectedGender = fetchedUserModel.gender;
          isLoading.value = false;
          log('Fetch User Data loading 3 : ${isLoading.value}');
        }
      }
    } catch (e) {
      log('Error fetching user data: $e');
      isLoading.value = false;
      // Handle errors here (e.g., show error message)
    }
  }

  void _checkIfEdited() {
    bool edited = nameController.text != userModel.value?.name ||
        emailController.text != userModel.value?.email ||
        phoneController.text != userModel.value?.phoneNumber ||
        userNameController.text != userModel.value?.userName ||
        bioController.text != userModel.value?.bio ||
        selectedGender != userModel.value?.gender;
    isEdited.value = edited;
  }

  Future<void> updateProfile() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserModel updatedUser = UserModel(
          id: userModel.value!.id,
          name: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          userName: userNameController.text,
          gender: selectedGender,
          bio: bioController.text,
        );

        await _firestoreService.updateUserDetails(updatedUser);

        showSnackBar('Success', 'Profile updated successfully');
        Get.back(result: updatedUser);
      } catch (e) {
        showSnackBar('Error', 'Failed to update profile');
        isLoading.value = false;
        log('$e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
