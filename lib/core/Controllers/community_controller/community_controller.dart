import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:image_picker/image_picker.dart';
import '../../model/community/post_model.dart';
import '../../model/community/comment_model.dart';
import '../../services/community/community_service.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();
  final CommunityService _communityService = Get.put(CommunityService());

  final ImagePicker _picker = ImagePicker();

  // Observables for posts and comments
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<CommentModel> currentPostComments = <CommentModel>[].obs;

  // Loading and error states
  RxBool isReacting = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingComments = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);

  // Filtering and pagination
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  Rx<Visibility?> selectedVisibility = Rx<Visibility?>(null);

  final RxString profileImageUrl = ''.obs;
  final RxString bannerImageUrl = ''.obs;

  // Stream subscriptions
  StreamSubscription? _postsSubscription;
  StreamSubscription? _commentsSubscription;

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = Category.all;
    fetchPostsRealTime();
  }

  // Fetch posts with advanced filtering
  void fetchPostsRealTime({
    Category? category,
    Visibility? visibility,
    PostType? postType,
  }) {
    // Reset previous state
    errorMessage.value = null;
    isLoading.value = true;
    _postsSubscription?.cancel();

    try {
      // If selected category is ALL, fetch all posts without any category filter
      if (selectedCategory.value == Category.all) {
        _postsSubscription = _communityService
            .getPostsStream(
          // Pass null for category to indicate no filtering
          category: null,
          visibility: visibility ?? selectedVisibility.value,
        )
            .listen(
          (newPosts) {
            posts.value = newPosts;
            isLoading.value = false;
          },
          onError: (error) {
            _handleError(error);
          },
        );
      } else {
        // For specific categories, apply the category filter
        _postsSubscription = _communityService
            .getPostsStream(
          category: category ?? selectedCategory.value,
          visibility: visibility ?? selectedVisibility.value,
        )
            .listen(
          (newPosts) {
            posts.value = newPosts;
            isLoading.value = false;
          },
          onError: (error) {
            _handleError(error);
          },
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  // Load comments for a specific post
  void loadPostComments(String postId) {
    _commentsSubscription?.cancel();
    errorMessage.value = null;

    isLoadingComments(true);
    try {
      _commentsSubscription =
          _communityService.getCommentsStream(postId).listen(
        (comments) {
          currentPostComments.value = comments;
        },
        onError: (error) {
          _handleError(error);
        },
      );
    } catch (e) {
      _handleError(e);
    } finally {
      isLoadingComments(false);
    }
  }

  // Add a comment with error handling
  Future<CommentModel?> addComment(CommentModel comment) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final addedComment = await _communityService.addComment(comment);
      isLoading.value = false;
      return addedComment;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Optimized react to post method
  void reactToPost(String postId, ReactionType reaction) {
    // Immediately update local state for responsiveness
    final postIndex = posts.indexWhere((post) => post.postId == postId);
    if (postIndex != -1) {
      final currentPost = posts[postIndex];

      // Predict local state change
      final updatedReactions =
          Map<ReactionType, int>.from(currentPost.reactions);
      final currentUserReaction = _getCurrentUserReaction(currentPost);

      // Adjust reaction counts
      int updatedLikeCount = currentPost.likeCount;
      if (currentUserReaction == reaction) {
        // Remove reaction
        updatedReactions[reaction] = (updatedReactions[reaction] ?? 1) - 1;
        updatedLikeCount--;
      } else if (currentUserReaction != null) {
        // Change reaction
        updatedReactions[currentUserReaction] =
            (updatedReactions[currentUserReaction] ?? 1) - 1;
        updatedReactions[reaction] = (updatedReactions[reaction] ?? 0) + 1;
      } else {
        // New reaction
        updatedReactions[reaction] = (updatedReactions[reaction] ?? 0) + 1;
        updatedLikeCount++;
      }

      // Update local post
      final updatedPost = currentPost.copyWith(
          reactions: updatedReactions, likeCount: updatedLikeCount);
      posts[postIndex] = updatedPost;

      // Start background update
      isReacting.value = true;
      _communityService.reactToPost(postId, reaction, (serverUpdatedPost) {
        // Sync with server response if needed
        posts[postIndex] = serverUpdatedPost;
        isReacting.value = false;
      }).catchError((error) {
        // Revert local changes if server update fails
        posts[postIndex] = currentPost;
        isReacting.value = false;
        _handleError(error);
      });
    }
  }

  // Helper method to get current user's reaction
  ReactionType? _getCurrentUserReaction(PostModel post) {
    final reactions = post.reactions;
    for (var reaction in reactions.keys) {
      if ((reactions[reaction] ?? 0) > 0) return reaction;
    }
    return null;
  }

  // Filter posts by category
  void filterByCategory(Category category) {
    selectedCategory.value = category;
    fetchPostsRealTime();
  }

  // Fetch posts for a specific user without using a stream
  Future<List<PostModel>?> fetchPostsByUserId(String userId) async {
    try {
      final userPosts = await _communityService.getPostsByUserId(userId);
      return userPosts;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Pick image
  Future<void> pickImage({required bool isProfile}) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (isProfile) {
          profileImageUrl.value =
              pickedFile.path; // Save local path temporarily
        } else {
          bannerImageUrl.value = pickedFile.path; // Save local path temporarily
        }
      }
    } catch (e) {
      log('Error: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  // Upload image to Firebase
  Future<String> _uploadImageToFirebase(File image, bool isProfile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(isProfile ? 'profile' : 'banner')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }

  // Update profile with images
  Future<bool> updateUserProfileWithImages(UserModel userModel) async {
    try {
      // Upload profile image if a new one was selected
      if (File(profileImageUrl.value).existsSync()) {
        final profileUrl =
            await _uploadImageToFirebase(File(profileImageUrl.value), true);
        userModel = userModel.copyWith(profileImageUrl: profileUrl);
      }

      // Upload banner image if a new one was selected
      if (File(bannerImageUrl.value).existsSync()) {
        final bannerUrl =
            await _uploadImageToFirebase(File(bannerImageUrl.value), false);
        userModel = userModel.copyWith(bannerImageUrl: bannerUrl);
      }

      // Update Firestore with user details
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.id)
          .update({
        'name': userModel.name,
        'userName': userModel.userName,
        'bio': userModel.bio,
        'profileImageUrl': userModel.profileImageUrl,
        'bannerImageUrl': userModel.bannerImageUrl,
      });

      // Update user model in controller
      UserController.instance.userModel.value = userModel;

      // Update user avatar in all posts
      final postsQuery = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userModel.id)
          .get();

      for (var doc in postsQuery.docs) {
        await doc.reference.update({'userAvatar': userModel.profileImageUrl});
      }

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      return false;
    }
  }

  // Universal error handling method
  void _handleError(dynamic error) {
    isLoading.value = false;

    if (error is CommunityServiceException) {
      errorMessage.value = error.message;

      // Optional: Log the error with stack trace
      print('Community Service Error: ${error.message}');
      if (error.stackTrace != null) {
        print('Stack Trace: ${error.stackTrace}');
      }
    } else {
      errorMessage.value = 'An unexpected error occurred';
    }

    // Optional: Show a snackbar or dialog
    Get.snackbar(
      'Error',
      errorMessage.value ?? 'Unknown error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _postsSubscription?.cancel();
    _commentsSubscription?.cancel();
    super.onClose();
  }
}
