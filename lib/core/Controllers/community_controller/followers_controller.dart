import 'dart:developer';

import 'package:conquest/core/model/user.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/community/followers_service.dart';
import '../user_controller.dart';

class FollowController extends GetxController {
  static FollowController get instance => Get.find();
  final FollowService _followService = FollowService();

  final userController = UserController.instance;

  // Reactive variables for followers and following using UserModel
  final RxList<UserModel> followers = <UserModel>[].obs;
  final RxList<UserModel> following = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Reactive variables for total followers and following count
  final RxInt totalFollowers = 0.obs;
  final RxInt totalFollowing = 0.obs;

  // Reactive variable for follow status of a specific user
  final RxMap<String, RxBool> followStatus = <String, RxBool>{}.obs;

  // Search users to follow
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final currentUserId = AuthService.instance.currentUser!.uid;
    log('Current user Id done');
    fetchTotalFollowers(currentUserId);
    fetchTotalFollowing(currentUserId);
    fetchFollowingAndUpdateStatus(currentUserId);
  }

  // Follow or unfollow a user
  Future<void> toggleFollow(String targetUserId) async {
    try {
      // Show immediate UI feedback by changing follow status
      if (followStatus.containsKey(targetUserId)) {
        followStatus[targetUserId]!.value = !followStatus[targetUserId]!.value;
      } else {
        followStatus[targetUserId] = true.obs;
      }

      // Delay state change to avoid errors during the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final currentUserId = userController.userModel.value?.id;
        if (currentUserId == null) return;

        // Toggle follow status on the backend
        await _followService.followUser(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
        // After updating backend, fetch followers/following lists again if necessary
        // await fetchFollowers(currentUserId);
        // await fetchFollowing(currentUserId);
        // You can re-fetch followers and following or update UI as necessary

        log('Toggle Done');
      });
    } catch (e) {
      errorMessage.value = 'Failed to toggle follow: ${e.toString()}';
    }
  }

  // Fetch followers for a user
  Future<void> fetchFollowers(String userId) async {
    followers.clear();

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get follower IDs
      final followerIds = await _followService.getFollowers(userId);

      // Convert follower IDs to detailed user models
      final followerDetails =
          await Future.wait(followerIds.map((followerId) async {
        final userModel = await userController.getUserDetail(followerId);
        return userModel;
      }));

      final validFollowerDetails =
          followerDetails.whereType<UserModel>().toList();
      followers.value = validFollowerDetails;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to fetch followers: ${e.toString()}';
    }
  }

  // Fetch users that a specific user is following
  Future<void> fetchFollowing(String userId) async {
    following.clear();

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get following IDs
      final followingIds = await _followService.getFollowing(userId);

      // Convert following IDs to detailed user models
      final followingDetails =
          await Future.wait(followingIds.map((followingId) async {
        final userModel = await userController.getUserDetail(followingId);
        return userModel;
      }));

      final validFollowingDetails =
          followingDetails.whereType<UserModel>().toList();

      following.value = validFollowingDetails;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to fetch following: ${e.toString()}';
    }
  }

  // Fetch total followers count
  Future<void> fetchTotalFollowers(String userId) async {
    try {
      final count = await _followService.getTotalFollowers(userId);
      totalFollowers.value = count;
    } catch (e) {
      errorMessage.value =
          'Failed to fetch total followers count: ${e.toString()}';
    }
  }

  // Fetch total following count
  Future<void> fetchTotalFollowing(String userId) async {
    try {
      final count = await _followService.getTotalFollowing(userId);
      totalFollowing.value = count;
    } catch (e) {
      errorMessage.value =
          'Failed to fetch total following count: ${e.toString()}';
    }
  }

  // Search users to follow
  Future<void> searchUsersToFollow(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await _followService.searchUsersToFollow(query);
      searchResults.value = results;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to search users: ${e.toString()}';
    }
  }

  // Check if currently following a user
  Future<bool> isFollowing(String targetUserId) async {
    try {
      // Get current user's ID (you might need to adjust this based on your auth setup)
      final currentUserId = userController.userModel.value?.id;

      if (currentUserId == null) return false;

      return await _followService.isFollowing(currentUserId, targetUserId);
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  // Fetch and update following list and follow status
  Future<void> fetchFollowingAndUpdateStatus(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get following IDs
      final followingIds = await _followService.getFollowing(userId);

      log('Followers: $followingIds');

      // Update follow status map
      followStatus.clear();
      for (var id in followingIds) {
        followStatus[id] = true.obs;
      }

      // Convert following IDs to detailed user models
      // final followingDetails =
      // await Future.wait(followingIds.map((followingId) async {
      //   final userModel = await userController.getUserDetail(followingId);
      //   return userModel;
      // }));
      //
      // final validFollowingDetails =
      // followingDetails.whereType<UserModel>().toList();
      // following.value = validFollowingDetails;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value =
          'Failed to fetch following and update status: ${e.toString()}';
    }
  }
}
