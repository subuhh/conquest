import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Controllers/community_controller/community_controller.dart';
import '../../../core/Controllers/user_controller.dart';
import '../../../core/model/community/comment_model.dart';
import '../../../core/model/community/post_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class FitnessCommentBottomSheet extends StatefulWidget {
  final PostModel post;

  const FitnessCommentBottomSheet({Key? key, required this.post})
      : super(key: key);

  @override
  _FitnessCommentBottomSheetState createState() =>
      _FitnessCommentBottomSheetState();

  // Static method to show the bottom sheet
  static void show(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => FitnessCommentBottomSheet(post: post),
    );
  }
}

class _FitnessCommentBottomSheetState extends State<FitnessCommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final CommunityController _communityController = CommunityController.instance;
  final UserController _userController = UserController.instance;

  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load comments when bottom sheet is opened
    _communityController.loadPostComments(widget.post.postId);
  }

  void _addComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    // Create comment model
    final newComment = CommentModel(
      commentId: '', // Backend will generate
      postId: widget.post.postId,
      userId: _userController.userModel.value?.id ?? '',
      userName: _userController.userModel.value?.userName ?? 'Anonymous',
      userAvatar: _userController.userModel.value?.profileImageUrl ?? '',
      content: commentText,
      createdAt: DateTime.now(),
    );

    try {
      await _communityController.addComment(newComment);
      _commentController.clear();
      _commentFocusNode.unfocus();
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to post comment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Title and Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Obx(() => Text(
                        '${_communityController.currentPostComments.length} Comments',
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ],
              ),
            ),

            // Comments List
            Expanded(
              child: _buildCommentsList(controller),
            ),

            // Comment Input
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsList(ScrollController scrollController) {
    return Obx(() {
      final comments = _communityController.currentPostComments;

      if (_communityController.isLoadingComments.value) {
        return const Center(
            child: CircularProgressIndicator(
          color: TColors.primary,
        ));
      }

      if (comments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No comments yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'Be the first to comment!',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: comments.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment.userAvatar),
            ),
            title: Text(
              comment.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(comment.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey[600]),
              onPressed: () {
                // TODO: Implement comment like functionality
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                _userController.userModel.value?.profileImageUrl != null
                    ? NetworkImage(
                        _userController.userModel.value!.profileImageUrl!)
                    : null,
            child: _userController.userModel.value?.profileImageUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              decoration: InputDecoration(
                hintText: 'Add a motivational comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: TColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _addComment,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 30) return '${difference.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
