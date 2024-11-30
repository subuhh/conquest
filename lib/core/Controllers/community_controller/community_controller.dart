import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide Visibility;
import '../../model/community/post_model.dart';
import '../../model/community/comment_model.dart';
import '../../services/community/community_service.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();
  final CommunityService _communityService = Get.put(CommunityService());

  // Observables for posts and comments
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<CommentModel> currentPostComments = <CommentModel>[].obs;

  // Loading and error states
  RxBool isLoading = false.obs;
  RxBool isLoadingComments = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);

  // Filtering and pagination
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  Rx<Visibility?> selectedVisibility = Rx<Visibility?>(null);

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

  // Create a new post with error handling
  Future<bool> createPost(PostModel post) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final createdPost = await _communityService.createPost(post);
      isLoading.value = false;
      return createdPost;
    } catch (e) {
      _handleError(e);
      return false;
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

  // React to a post with error handling
  Future<PostModel?> reactToPost(String postId, ReactionType reaction) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final updatedPost = await _communityService.reactToPost(postId, reaction);
      isLoading.value = false;
      return updatedPost;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Filter posts by category
  void filterByCategory(Category category) {
    selectedCategory.value = category;
    fetchPostsRealTime();
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
