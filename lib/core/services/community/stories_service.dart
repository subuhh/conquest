import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../model/user.dart';
import '../../model/community/stories_model.dart';

class StoriesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload story media to Firebase Storage
  Future<String> _uploadStoryMedia(File mediaFile, String userId) async {
    try {
      final storageRef = _storage
          .ref()
          .child('Stories/$userId/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(mediaFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading story media: $e');
      rethrow;
    }
  }

  // Get current user's active stories
  Future<List<StoryModel>> getCurrentUserActiveStories(String userId) async {
    final now = DateTime.now();
    final querySnapshot = await _firestore
        .collection('Stories')
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: now)
        .orderBy('expiresAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => StoryModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Get stories from followed users
  Future<List<List<StoryModel>>> getFollowedUsersStories(
      String currentUserId) async {
    try {
      // First, get the list of users the current user follows
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      // Check if user document exists and has following list
      if (!userDoc.exists) {
        print('User document not found for ID: $currentUserId');
        return [];
      }

      final userData = userDoc.data();
      if (userData == null) {
        print('User data is null for ID: $currentUserId');
        return [];
      }

      final UserModel currentUser =
          UserModel.fromFirestore(userDoc.data()!, currentUserId);

      // Check if followingIds is null or empty
      final followersIds = currentUser.followers ?? [];
      if (followersIds.isEmpty) {
        print('No followers users found');
        return [];
      }

      final now = DateTime.now();

      List<List<StoryModel>> storiesList = [];

      for (var userId in followersIds) {
        final querySnapshot = await _firestore
            .collection('Stories')
            .where('userId', isEqualTo: userId)
            .where('expiresAt', isGreaterThan: now)
            .orderBy('expiresAt', descending: true)
            .get();

        final userStories = querySnapshot.docs
            .map((doc) => StoryModel.fromMap(doc.data(), doc.id))
            .toList();

        storiesList.add(userStories);
      }

      return storiesList;
    } catch (e) {
      print('Error fetching followed users stories: $e');
      return [];
    }
  }

  // Create a new story or add to existing active story collection
  Future<StoryModel> createStory({
    required String userId,
    required File mediaFile,
    required String userAvatar,
    StoryMediaType? mediaType,
    String? caption,
  }) async {
    try {
      // Upload media and get URL
      final mediaUrl = await _uploadStoryMedia(mediaFile, userId);

      // Determine media type if not provided
      final determineMediaType = mediaType ??
          (mediaFile.path.toLowerCase().endsWith('mp4')
              ? StoryMediaType.video
              : StoryMediaType.image);

      // Set expiration time (e.g., 24 hours from now)
      final expiresAt = DateTime.now().add(Duration(hours: 24));

      // Create story model
      final story = StoryModel(
        userId: userId,
        mediaUrl: mediaUrl,
        mediaType: determineMediaType,
        caption: caption,
        expiresAt: expiresAt,
        userAvatar: userAvatar,
      );

      final docRef = await _firestore.collection('Stories').add(story.toMap());
      return StoryModel.fromMap({...story.toMap(), 'id': docRef.id}, docRef.id);
    } catch (e) {
      print('Error creating story: $e');
      rethrow;
    }
  }

  // Mark story as viewed
  Future<void> markStoryAsViewed(String storyId, String viewerId) async {
    try {
      await _firestore.collection('Stories').doc(storyId).update({
        'viewedBy': FieldValue.arrayUnion([viewerId])
      });
    } catch (e) {
      print('Error marking story as viewed: $e');
      rethrow;
    }
  }

  // Mark story as viewed
  Future<void> markStoryAsLiked(String storyId, String likedId) async {
    try {
      await _firestore.collection('Stories').doc(storyId).update({
        'likedBy': FieldValue.arrayUnion([likedId])
      });
    } catch (e) {
      print('Error marking story as viewed: $e');
      rethrow;
    }
  }

  // Add a comment to a story
  Future<CommentModel> addCommentToStory({
    required String storyId,
    required String userId,
    required String text,
    String? userAvatar,
  }) async {
    try {
      // Create a new comment
      final comment = CommentModel(
        userId: userId,
        text: text,
        userAvatar: userAvatar,
      );

      // Add comment to the story's comments array in Firestore
      await _firestore.collection('Stories').doc(storyId).update({
        'comments': FieldValue.arrayUnion([comment.toMap()])
      });

      return comment;
    } catch (e) {
      print('Error adding comment to story: $e');
      rethrow;
    }
  }

  // Delete expired stories
  Future<void> deleteExpiredStories() async {
    final now = DateTime.now();
    final expiredStoriesQuery = await _firestore
        .collection('Stories')
        .where('expiresAt', isLessThan: now)
        .get();

    for (var doc in expiredStoriesQuery.docs) {
      // Delete from Firestore
      await doc.reference.delete();

      // Optional: Delete from storage
      try {
        final storageRef = _storage.refFromURL(doc['mediaUrl']);
        await storageRef.delete();
      } catch (e) {
        print('Error deleting story media from storage: $e');
      }
    }
  }
}
