import 'dart:developer';
import 'dart:io';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import '../../../../core/model/user.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final userController = UserController.instance;
  final auth = AuthService.instance;

  var isLoading = true.obs;
  var isEdited = false.obs;

  var profileImage = Rx<File?>(null);

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController userNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  String? selectedGender;
  UserModel? userModel;

  @override
  void onInit() {
    super.onInit();
    userModel = userController.userModel.value;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      if (userModel != null) {
        nameController = TextEditingController(text: userModel!.name)
          ..addListener(_checkIfEdited);
        userNameController = TextEditingController(text: userModel!.userName)
          ..addListener(_checkIfEdited);
        emailController = TextEditingController(text: userModel!.email)
          ..addListener(_checkIfEdited);
        phoneController = TextEditingController(text: userModel!.phoneNumber)
          ..addListener(_checkIfEdited);
        bioController = TextEditingController(text: userModel!.bio)
          ..addListener(_checkIfEdited);
        selectedGender = userModel!.gender;
      }
    } catch (e) {
      log('Error fetching user data: $e');
    } finally {
      isLoading(false);
    }
  }

  void _checkIfEdited() {
    bool edited = nameController.text != userModel!.name ||
        emailController.text != userModel!.email ||
        phoneController.text != userModel!.phoneNumber ||
        userNameController.text != userModel!.userName ||
        bioController.text != userModel!.bio ||
        selectedGender != userModel!.gender;
    isEdited.value = edited;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        isEdited.value = true;
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<String?> _uploadProfileImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images').child(userModel!.id);
      final uploadTask = await storageRef.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String? imageUrl;
        if (profileImage.value != null) {
          imageUrl = await _uploadProfileImage(profileImage.value!);
        }

        UserModel updatedUser = userModel!.copyWith(
          id: userModel!.id,
          name: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          userName: userNameController.text,
          gender: selectedGender,
          bio: bioController.text,
          profileImageUrl: imageUrl ?? userModel!.profileImageUrl,
        );

        await _firestoreService.updateUserDetails(updatedUser);

        userController.userModel.value = updatedUser;

        showSnackBar('Success', 'Profile updated successfully');

        Navigator.pop(context);

      } catch (e) {
        showSnackBar('Error', 'Failed to update profile');
        log('$e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
