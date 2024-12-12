import 'dart:typed_data';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/services/community/community_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:get/get.dart';
import '../../model/community/post_model.dart';

class PostCreationController extends GetxController {
  static PostCreationController get instance => Get.find();

  // Observable list of selected media files
  RxList<MediaFile> selectedMedia = <MediaFile>[].obs;

  // Post content controller
  final TextEditingController contentController = TextEditingController();

  // Selected category
  Rx<Category> selectedCategory = Category.all.obs;

  // Selected hashtags
  RxList<String> selectedHashtags = <String>[].obs;

  // Loading
  RxBool isLoading = false.obs;

  void removeMediaItem(int index) {
    selectedMedia.removeAt(index);
  }

  // Rest of the code remains the same as in the original implementation...
  Future<bool> createPost() async {
    isLoading(true);
    try {
      final userController = UserController.instance.userModel.value;

      // Validate post creation
      if (contentController.text.isEmpty && selectedMedia.isEmpty) {
        Get.snackbar('Validation', 'Post content or media is required');
        return false;
      }

      // Upload media files
      final uploadedUrls = await _uploadMediaFiles(
        selectedMedia,
      );

      // Determine post type based on media
      final postType = selectedMedia.isEmpty
          ? PostType.text
          : (selectedMedia.first.type == MediaType.video
              ? PostType.video
              : PostType.image);

      // Create PostModel
      final postModel = PostModel(
        postId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userController!.id,
        userName: userController.userName,
        userAvatar: userController.profileImageUrl ?? '',
        createdAt: DateTime.now(),
        postType: postType,
        content: contentController.text,
        mediaUrls: uploadedUrls.isNotEmpty ? uploadedUrls : null,
        category: selectedCategory.value,
        hashtags: selectedHashtags,
        visibility: Visibility.public,
      );

      // Call Firebase service to create post
      final success = await CommunityService.instance.createPost(postModel);

      if (success) {
        // Clear all fields
        contentController.clear();
        selectedMedia.clear();
        selectedHashtags.clear();
        Get.back(); // Close bottom sheet
        Get.back(); // Close bottom sheet
        Get.back(); // Close bottom sheet
        Get.snackbar('Success', 'Post created successfully');
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create post: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Update media upload method to handle the new MediaFile type
  Future<List<String>> _uploadMediaFiles(
    List<MediaFile> mediaFiles,
  ) async {
    try {
      List<String> uploadedUrls = [];

      for (var mediaFile in mediaFiles) {
        final userId = UserController.instance.userModel.value?.id ?? 'unknown';

        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            (mediaFile.type == MediaType.image ? '.png' : '.mp4');

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts')
            .child(userId)
            .child(mediaFile.type == MediaType.image ? 'images' : 'videos')
            .child(fileName);

        // Upload media based on its type
        UploadTask uploadTask;
        if (mediaFile.type == MediaType.image && mediaFile.file is Uint8List) {
          uploadTask = storageRef.putData(mediaFile.file as Uint8List);
        } else if (mediaFile.type == MediaType.video) {
          uploadTask = storageRef.putFile(mediaFile.file);
        } else {
          continue; // Skip if media type does not match
        }

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      }

      return uploadedUrls;
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        'Failed to upload media: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  void addHashtag(String hashtag) {
    if (!selectedHashtags.contains(hashtag)) {
      selectedHashtags.add(hashtag);
    }
  }

  void removeHashtag(String hashtag) {
    selectedHashtags.remove(hashtag);
  }
}

// Media file class to handle both images and videos
class MediaFile {
  final dynamic file;
  final MediaType type;

  MediaFile({required this.file, required this.type});
}

enum MediaType { image, video }
