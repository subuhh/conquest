import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/Controllers/community_controller/community_controller.dart';
import 'package:conquest/core/Controllers/community_controller/followers_controller.dart';
import 'package:conquest/core/Controllers/report_controller.dart';
import 'package:conquest/features/Community/Post/Post_Card/post_footer.dart';
import 'package:conquest/features/Community/Post/Post_Card/post_media_creation.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/model/community/post_model.dart';
import 'package:get/get.dart';
import '../../../../core/services/auth_service.dart';
import '../../Profile/user_community_profile.dart';
import '../../widgets/enlarge_image.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  PostCardWidget({super.key, required this.post});

  final _controller = CommunityController.instance;
  final followersController = FollowController.instance;
  final currentUserId = AuthService.instance.currentUser!.uid;
  final reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post, context),
          _buildPostContent(post),
          _buildPostFooter(post),
        ],
      ),
    );
  }

  Widget _buildPostHeader(PostModel post, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  EnlargeImage.showZoomableImage(post.userAvatar, context);
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(post.userAvatar),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CommunityProfileScreen(userId: post.userId),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      post.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatDateTime(post.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              if (currentUserId != post.userId)
                ElevatedButton(
                  onPressed: () {
                    followersController.toggleFollow(post.userId);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black87, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Obx(() {
                    // Check if postUserId is in followStatus map and if true, show 'Following' otherwise 'Follow'
                    final isFollowing = followersController.followStatus
                            .containsKey(post.userId) &&
                        followersController.followStatus[post.userId]!.value;

                    return Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                          color: isFollowing ? Colors.black54 : Colors.black),
                    );
                  }),
                ),
              Spacer(),
              if (post.userId != currentUserId)
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 16,
                  child: GestureDetector(
                    child: const Icon(Icons.more_horiz),
                    onTap: () {
                      _showCustomBottomSheet(context, post);
                    },
                  ),
                ),
            ],
          ),
          if (post.content != null && post.content!.isNotEmpty) ...[
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ReadMoreText(
                    post.content!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    trimLines: 1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' more',
                    trimExpandedText: 'show less',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }

  Widget _buildPostContent(PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Support for multiple media types
        if (post.mediaUrls != null && post.mediaUrls!.isNotEmpty)
          MediaCarouselWidget(
            mediaUrls: post.mediaUrls!,
            postModel: post,
          ),

        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPostFooter(PostModel post) {
    return PostFooter(
      post: post,
      controller: _controller,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${dateTime.day} ${monthNames[dateTime.month - 1]}';
    } else {
      return '${dateTime.day} ${monthNames[dateTime.month - 1]} ${dateTime.year}';
    }
  }

  void _showCustomBottomSheet(BuildContext context, PostModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow height control
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom ListTile with Report tile
                _customListTile(
                  "Report",
                  Icons.report,
                  Colors.red,
                  () {
                    reportController.submitReport(
                      reportedUserId: post.userId,
                      reportType: 'Post',
                      reportByUserId: currentUserId,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _customListTile(
      String title, IconData icon, Color color, void Function()? onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
