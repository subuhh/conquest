import 'dart:developer';

import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../model/community/stories_model.dart';
import '../../services/community/stories_service.dart';

class StoriesController extends GetxController {
  static StoriesController get instance => Get.find();

  final StoriesService _storiesService = StoriesService();

  // List of other users' stories
  final RxList<List<StoryModel>> followedUsersStories =
      <List<StoryModel>>[].obs;

  // Stories of Current user
  final RxList<StoryModel> currentUserStories = <StoryModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch current user and followed users' stories
    fetchUserStories();

    // Periodically clean up expired stories
    _startExpiredStoriesCleaner();
  }

  // Fetch stories for current user and followed users
  Future<void> fetchUserStories() async {
    try {
      isLoading.value = true;

      // Fetch current user's active stories
      currentUserStories.value =
          await _storiesService.getCurrentUserActiveStories(getCurrentUserId());

      // Fetch stories from followed users
      followedUsersStories.value =
          await _storiesService.getFollowedUsersStories(getCurrentUserId());
    } catch (e) {
      log('Error fetching stories: $e');
      Get.snackbar('Error', 'Failed to load stories');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to create a story using MediaPickerController
  Future<void> createStoryFromMedia(File mediaFile, {String? caption}) async {
    try {
      isLoading.value = true;

      // Determine media type
      final mediaType = mediaFile.path.toLowerCase().endsWith('mp4')
          ? StoryMediaType.video
          : StoryMediaType.image;

      // Create story
      await _storiesService.createStory(
          userId: getCurrentUserId(),
          mediaFile: mediaFile,
          mediaType: mediaType,
          userAvatar:
              UserController.instance.userModel.value?.profileImageUrl ?? '',
          caption: caption);

      // Refresh stories after creation
      await fetchUserStories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create story');
      print('Story creation error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // View a specific story
  void viewStory(StoryModel story) {
    // Mark as viewed if not already viewed
    if (!story.viewedBy.contains(getCurrentUserId())) {
      _storiesService.markStoryAsViewed(story.id!, getCurrentUserId());
    }
  }

  // Like a specific story
  void likeStory(StoryModel story) {
    // Mark as liked if not already liked
    if (!story.likedBy.contains(getCurrentUserId())) {
      _storiesService.markStoryAsLiked(story.id!, getCurrentUserId());
    }
  }

  void addCommentToStory({
    required String storyId,
    required String userId,
    required String text,
    String? userAvatar,
  }) {
    _storiesService.addCommentToStory(
      storyId: storyId,
      userId: userId,
      text: text,
      userAvatar: userAvatar,
    );
  }

  void _startExpiredStoriesCleaner() {
    // Periodic cleanup of expired stories
    ever(currentUserStories, (_) {
      _storiesService.deleteExpiredStories();
    });
  }

  // Helper method to get current user ID (implement your authentication logic)
  String getCurrentUserId() {
    return AuthService.instance.currentUser!.uid;
  }
}
