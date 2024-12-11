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

  Future<void> reactToPost(String postId, ReactionType reaction,
      void Function(PostModel)? onReactionUpdate) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw CommunityServiceException('User not authenticated');
      }

      final postRef = _firestore.collection('posts').doc(postId);
      final userReactionRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('post_reactions')
          .doc(postId);

      // Optimized transaction with all reads first
      await _firestore.runTransaction((transaction) async {
        // Perform ALL reads first
        final postDoc = await transaction.get(postRef);
        final userReactionDoc = await transaction.get(userReactionRef);

        if (!postDoc.exists) {
          throw CommunityServiceException('Post does not exist');
        }

        final postData = postDoc.data() as Map<String, dynamic>;
        final currentReactions =
            (postData['reactions'] as Map<String, dynamic>?) ?? {};
        final currentUserReaction = userReactionDoc.exists
            ? userReactionDoc.data()!['reaction'] as String?
            : null;

        // Prepare all updates based on reads
        final updates = <String, dynamic>{};
        bool shouldDeleteUserReaction = false;
        bool shouldCreateUserReaction = false;
        int likeCountChange = 0;

        // Reaction logic
        if (currentUserReaction == reaction.toString()) {
          // Remove reaction if same reaction is clicked again
          final newReactions = {
            ...currentReactions,
            reaction.toString():
                (currentReactions[reaction.toString()] ?? 1) - 1
          };
          updates['reactions'] = newReactions;
          shouldDeleteUserReaction = true;
          likeCountChange = -1;
        } else if (currentUserReaction != null) {
          // Change from one reaction to another
          final prevReaction = currentUserReaction;
          final newReactions = {
            ...currentReactions,
            prevReaction: (currentReactions[prevReaction] ?? 1) - 1,
            reaction.toString():
                (currentReactions[reaction.toString()] ?? 0) + 1
          };
          updates['reactions'] = newReactions;
          shouldCreateUserReaction = true;
        } else {
          // First time reaction
          final newReactions = {
            ...currentReactions,
            reaction.toString():
                (currentReactions[reaction.toString()] ?? 0) + 1
          };
          updates['reactions'] = newReactions;
          shouldCreateUserReaction = true;
          likeCountChange = 1;
        }

        // Update like count if changed
        if (likeCountChange != 0) {
          updates['likeCount'] = (postData['likeCount'] ?? 0) + likeCountChange;
        }

        // Perform ALL writes AFTER all reads
        // Writes section
        if (shouldDeleteUserReaction) {
          transaction.delete(userReactionRef);
        }

        if (shouldCreateUserReaction) {
          transaction.set(userReactionRef, {
            'reaction': reaction.toString(),
            'postId': postId,
            'timestamp': FieldValue.serverTimestamp()
          });
        }

        if (updates.isNotEmpty) {
          transaction.update(postRef, updates);
        }

        return null; // Return value required by runTransaction
      });

      // Fetch updated post outside the transaction
      final updatedPostDoc = await postRef.get();
      final updatedPostData = updatedPostDoc.data() as Map<String, dynamic>;
      final updatedPost = PostModel.fromJson(updatedPostData);

      // Optional callback for immediate UI update
      onReactionUpdate?.call(updatedPost);
    } catch (e, stackTrace) {
      throw CommunityServiceException(
          'Failed to react to post: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  // Fetch posts for a specific user without using a stream
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final posts = querySnapshot.docs.map((doc) {
        try {
          return PostModel.fromJson(doc.data());
        } catch (e) {
          print('Error parsing post: ${e.toString()}');
          return null;
        }
      }).whereType<PostModel>().toList();

      return posts;
    } catch (e, stackTrace) {
      throw CommunityServiceException(
          'Failed to fetch posts by user ID: ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

}
