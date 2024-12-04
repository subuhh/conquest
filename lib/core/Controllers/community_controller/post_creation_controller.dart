import 'dart:io';
import 'dart:typed_data';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/services/community/community_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import '../../model/community/post_model.dart';

class PostCreationController extends GetxController {
  static PostCreationController get instance => Get.find();
  final ImagePicker _picker = ImagePicker();

  // Observable list of selected media files
  RxList<MediaFile> selectedMedia = <MediaFile>[].obs;

  // Post content controller
  final TextEditingController contentController = TextEditingController();

  // Selected post type
  Rx<PostType> selectedPostType = PostType.text.obs;

  // Selected category
  Rx<Category> selectedCategory = Category.all.obs;

  // Selected hashtags
  RxList<String> selectedHashtags = <String>[].obs;

  // Loading
  RxBool isLoading = false.obs;

  Future<void> pickMultipleMedia() async {
    try {
      // Check if media limit is reached
      if (selectedMedia.length >= 10) {
        Get.snackbar(
          'Limit Reached',
          'You can only add up to 10 media files',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Show a dialog to choose media source
      await Get.dialog(
        AlertDialog(
          title: Text('Select Media Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Get.back();
                  pickMediaFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Get.back();
                  captureMediaFromCamera();
                },
              ),
            ],
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      _handleMediaPickError(e);
    }
  }

  Future<void> pickMediaFromGallery() async {
    try {
      // Remaining media slots
      final remainingSlots = 10 - selectedMedia.length;

      if (remainingSlots <= 0) {
        Get.snackbar(
          'Limit Reached',
          'You can only add up to 10 media files',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Pick mixed media (images and videos)
      final List<XFile> pickedFiles = await _picker.pickMultipleMedia(
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 80,
        // maxVideoDuration: const Duration(minutes: 1),
      );

      // Process picked media while preserving order and respecting slot limit
      for (var pickedFile in pickedFiles) {
        if (selectedMedia.length >= 10) break;

        if (pickedFile.path.toLowerCase().endsWith('.mp4') ||
            pickedFile.path.toLowerCase().endsWith('.mov')) {
          // Video processing
          final fileSize = await File(pickedFile.path).length();
          if (fileSize > 50 * 1024 * 1024) {
            Get.snackbar(
              'Error',
              'Video size must be less than 50 MB',
              snackPosition: SnackPosition.BOTTOM,
            );
            continue;
          }

          // Compress video
          final compressedVideo = await _compressVideo(File(pickedFile.path));

          if (compressedVideo != null) {
            selectedMedia.add(
              MediaFile(
                file: compressedVideo,
                type: MediaType.video,
              ),
            );
          }
        } else {
          // Image processing
          selectedMedia.add(
            MediaFile(
              file: File(pickedFile.path),
              type: MediaType.image,
            ),
          );
        }
      }
    } catch (e) {
      _handleMediaPickError(e);
    }
  }

  Future<void> captureMediaFromCamera() async {
    try {
      // Remaining media slots
      final remainingSlots = 10 - selectedMedia.length;

      if (remainingSlots <= 0) {
        Get.snackbar(
          'Limit Reached',
          'You can only add up to 10 media files',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Request camera permissions
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        Get.snackbar('Permission', 'Camera permission is required');
        return;
      }

      // Determine which type of media to capture
      await Get.dialog(
        AlertDialog(
          title: Text('Capture Media'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Capture Photo'),
                onTap: () async {
                  Get.back();
                  await _capturePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Record Video'),
                onTap: () async {
                  Get.back();
                  await _recordVideo();
                },
              ),
            ],
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      _handleMediaPickError(e);
    }
  }

  Future<void> _capturePhoto() async {
    try {
      // Remaining media slots
      if (selectedMedia.length >= 10) {
        Get.snackbar(
          'Limit Reached',
          'You can only add up to 10 media files',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Capture image
      final XFile? pickedImageFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 80,
      );

      // Add image if captured
      if (pickedImageFile != null && selectedMedia.length < 10) {
        selectedMedia.add(
          MediaFile(
            file: File(pickedImageFile.path),
            type: MediaType.image,
          ),
        );
      }
    } catch (e) {
      _handleMediaPickError(e);
    }
  }

  Future<void> _recordVideo() async {
    try {
      // Remaining media slots
      if (selectedMedia.length >= 10) {
        Get.snackbar(
          'Limit Reached',
          'You can only add up to 10 media files',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Capture video
      final XFile? pickedVideoFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 1),
      );

      // Add video if captured
      if (pickedVideoFile != null && selectedMedia.length < 10) {
        // Check video file size
        final fileSize = await pickedVideoFile.length();
        if (fileSize > 50 * 1024 * 1024) {
          Get.snackbar(
            'Error',
            'Video size must be less than 50 MB',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Compress video
        final compressedVideo =
            await _compressVideo(File(pickedVideoFile.path));

        if (compressedVideo != null) {
          selectedMedia.add(
            MediaFile(
              file: compressedVideo,
              type: MediaType.video,
            ),
          );
        }
      }
    } catch (e) {
      _handleMediaPickError(e);
    }
  }

  Future<File?> _compressVideo(File videoFile) async {
    try {
      // Compress video
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (mediaInfo != null && mediaInfo.file != null) {
        return mediaInfo.file;
      }

      return null;
    } catch (e) {
      Get.snackbar(
        'Compression Error',
        'Failed to compress video: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

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
        } else if (mediaFile.type == MediaType.video &&
            mediaFile.file is File) {
          uploadTask = storageRef.putFile(mediaFile.file as File);
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

  void _handleMediaPickError(dynamic error) {
    Get.snackbar(
      'Error',
      'Failed to pick media: ${error.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
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
