import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../model/community/post_model.dart';
import '../../model/community/comment_model.dart';

class CommunityServiceException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  CommunityServiceException(this.message, {this.stackTrace});

  @override
  String toString() {
    return 'CommunityServiceException: $message';
  }
}

class CommunityService extends GetxService {
  static CommunityService get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new post with comprehensive error handling
  Future<bool> createPost(PostModel post) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw CommunityServiceException('User not authenticated');
      }

      await _firestore.collection('posts').doc(post.postId).set(post.toJson());
      return true;
    } catch (e, stackTrace) {
      throw CommunityServiceException('Failed to create post: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  // Stream posts with advanced filtering and error handling
  Stream<List<PostModel>> getPostsStream({
    int limit = 10,
    Category? category,
    Visibility? visibility,
    DateTime? startDate,
    DateTime? endDate,
    PostType? postType,
  }) {
    try {
      Query query = _firestore.collection('posts');

      // Apply filters
      if (category != null) {
        query = query.where('category', isEqualTo: category.toString());
      }

      if (visibility != null) {
        query = query.where('visibility', isEqualTo: visibility.toString());
      }

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }

      if (postType != null) {
        query = query.where('postType', isEqualTo: postType.toString());
      }

      // Order and limit
      query = query.orderBy('createdAt', descending: true).limit(limit);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return PostModel.fromJson(doc.data() as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing post: ${e.toString()}');
                return null;
              }
            })
            .whereType<PostModel>()
            .toList();
      }).handleError((error) {
        throw CommunityServiceException('Error streaming posts: $error');
      });
    } catch (e, stackTrace) {
      throw CommunityServiceException(
          'Failed to create posts stream: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  // Add a comment with comprehensive error handling
  Future<CommentModel> addComment(CommentModel comment) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw CommunityServiceException('User not authenticated');
      }

      // Validate post exists
      final postDoc =
          await _firestore.collection('posts').doc(comment.postId).get();
      if (!postDoc.exists) {
        throw CommunityServiceException('Post does not exist');
      }

      // Create comment with additional metadata
      final finalComment = CommentModel(
        commentId: Uuid().v4(),
        postId: comment.postId,
        userId: user.uid,
        userName: comment.userName,
        userAvatar: comment.userAvatar,
        content: comment.content,
        createdAt: DateTime.now(),
      );

      // Add comment to post's comments subcollection
      await _firestore
          .collection('posts')
          .doc(comment.postId)
          .collection('comments')
          .doc(finalComment.commentId)
          .set(finalComment.toJson());

      // Increment comment count in the post document
      await _firestore
          .collection('posts')
          .doc(comment.postId)
          .update({'commentCount': FieldValue.increment(1)});

      return finalComment;
    } catch (e, stackTrace) {
      throw CommunityServiceException('Failed to add comment: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  // Stream comments for a specific post
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return CommentModel.fromJson(doc.data());
              } catch (e) {
                print('Error parsing comment: ${e.toString()}');
                return null;
              }
            })
            .whereType<CommentModel>()
            .toList();
      }).handleError((error) {
        throw CommunityServiceException('Error streaming comments: $error');
      });
    } catch (e, stackTrace) {
      throw CommunityServiceException(
          'Failed to create comments stream: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  // Engage with post (like, reaction)
  Future<PostModel> reactToPost(String postId, ReactionType reaction) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw CommunityServiceException('User not authenticated');
      }

      final postRef = _firestore.collection('posts').doc(postId);
      final postDoc = await postRef.get();

      if (!postDoc.exists) {
        throw CommunityServiceException('Post does not exist');
      }

      // Update reactions and like count
      await postRef.update({
        'reactions.${reaction.toString()}': FieldValue.increment(1),
        'likeCount': FieldValue.increment(1),
      });

      // Fetch updated post
      final updatedPostDoc = await postRef.get();
      return PostModel.fromJson(updatedPostDoc.data() as Map<String, dynamic>);
    } catch (e, stackTrace) {
      throw CommunityServiceException(
          'Failed to react to post: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }
}
