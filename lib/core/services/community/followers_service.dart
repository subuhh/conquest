import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the total number of followers for a user
  Future<int> getTotalFollowers(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['totalFollowers'] ?? 0;
    } catch (e) {
      print('Error in getTotalFollowers: $e');
      return 0;
    }
  }

  // Get the total number of following for a user
  Future<int> getTotalFollowing(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['totalFollowing'] ?? 0;
    } catch (e) {
      print('Error in getTotalFollowing: $e');
      return 0;
    }
  }

  // Follow a user
  Future<bool> followUser(
      {required String currentUserId, required String targetUserId}) async {
    try {
      // Transaction to ensure atomic operations
      return await _firestore.runTransaction((transaction) async {
        // References to current user and target user documents
        final currentUserRef =
            _firestore.collection('users').doc(currentUserId);
        final targetUserRef = _firestore.collection('users').doc(targetUserId);

        // Fetch current user and target user snapshots
        final currentUserSnapshot = await transaction.get(currentUserRef);
        final targetUserSnapshot = await transaction.get(targetUserRef);

        if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
          throw Exception('User does not exist');
        }

        // Check if already following
        final followingList =
            List<String>.from(currentUserSnapshot.data()?['following'] ?? []);
        final targetFollowersList =
            List<String>.from(targetUserSnapshot.data()?['followers'] ?? []);

        if (followingList.contains(targetUserId)) {
          // Already following, so unfollow
          followingList.remove(targetUserId);
          targetFollowersList.remove(currentUserId);

          // Decrease follower count for target user
          final currentFollowers =
              targetUserSnapshot.data()?['totalFollowers'] ?? 0;
          transaction.update(targetUserRef, {
            'totalFollowers': currentFollowers > 0 ? currentFollowers - 1 : 0,
            'followers': targetFollowersList
          });

          // Update current user's following list
          transaction.update(currentUserRef, {
            'following': followingList,
            'totalFollowing': followingList.length
          });

          return false; // Indicates unfollowed
        } else {
          // Follow user
          followingList.add(targetUserId);
          targetFollowersList.add(currentUserId);

          // Increase follower count for target user
          final currentFollowers =
              targetUserSnapshot.data()?['totalFollowers'] ?? 0;
          transaction.update(targetUserRef, {
            'totalFollowers': currentFollowers + 1,
            'followers': targetFollowersList
          });

          // Update current user's following list
          transaction.update(currentUserRef, {
            'following': followingList,
            'totalFollowing': followingList.length
          });

          return true; // Indicates followed
        }
      });
    } catch (e) {
      print('Error in followUser: $e');
      return false;
    }
  }

  // Get followers of a user
  Future<List<String>> getFollowers(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return List<String>.from(userDoc.data()?['followers'] ?? []);
    } catch (e) {
      print('Error in getFollowers: $e');
      return [];
    }
  }

  // Get users that a specific user is following
  Future<List<String>> getFollowing(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return List<String>.from(userDoc.data()?['following'] ?? []);
    } catch (e) {
      print('Error in getFollowing: $e');
      return [];
    }
  }

  // Get detailed follower/following information
  Future<List<Map<String, dynamic>>> getFollowerDetails(String userId) async {
    try {
      final followers = await getFollowers(userId);

      // Fetch details for each follower
      final followerDetails =
          await Future.wait(followers.map((followerId) async {
        final userDoc =
            await _firestore.collection('users').doc(followerId).get();
        return {
          'id': followerId,
          'name': userDoc.data()?['name'] ?? '',
          'userName': userDoc.data()?['userName'] ?? '',
          'profileImageUrl': userDoc.data()?['profileImageUrl'] ?? '',
        };
      }));

      return followerDetails;
    } catch (e) {
      print('Error in getFollowerDetails: $e');
      return [];
    }
  }

  // Check if current user is following a specific user
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      final following = List<String>.from(userDoc.data()?['following'] ?? []);
      return following.contains(targetUserId);
    } catch (e) {
      print('Error in isFollowing: $e');
      return false;
    }
  }

  // Search users to follow
  Future<List<Map<String, dynamic>>> searchUsersToFollow(String query) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return [];

      final querySnapshot = await _firestore
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('userName',
              isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
          .limit(10)
          .get();

      final users = await Future.wait(querySnapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) async {
        final data = doc.data();
        final isFollowings = await isFollowing(currentUserId, doc.id);

        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'userName': data['userName'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'isFollowing': isFollowings,
        };
      }));

      return users;
    } catch (e) {
      print('Error in searchUsersToFollow: $e');
      return [];
    }
  }
}
