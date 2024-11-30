import 'package:conquest/features/Community/Post/post_creation_bottom_sheet.dart';
import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../core/Controllers/community_controller/community_controller.dart';
import '../../core/model/community/post_model.dart';
import 'Category_Filter/category_filter_bottom_sheet.dart';
import 'Post/post_footer.dart';
import 'Post/post_media_creation.dart';

class CommunityFeedPage extends StatelessWidget {
  final CommunityController _controller = Get.put(CommunityController());

  CommunityFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategoryChips(),
            _buildPostList(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButton: _buildCreatePostButton(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Community',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      actions: [
        // Elegant Filter and Add Icons
        GestureDetector(
          onTap: _showCategoryFilter,
          child: SvgPicture.asset(
            'assets/icons/community/filter.svg',
            height: 27,
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Obx(() => Wrap(
              spacing: 12,
              children: Category.values
                  .map(
                    (category) => ChoiceChip(
                      label: Text(
                        category.name.capitalize!,
                        style: TextStyle(
                          color: _controller.selectedCategory.value == category
                              ? Colors.white
                              : Colors.black87,
                          // fontSize: 14
                        ),
                      ),
                      showCheckmark: false,
                      // side: BorderSide.,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      selected: _controller.selectedCategory.value == category,
                      onSelected: (_) => _controller.filterByCategory(category),
                      selectedColor: TColors.black,
                      backgroundColor: TColors.secondaryBackground,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  )
                  .toList(),
            )),
      ),
    );
  }

  Widget _buildPostList() {
    return Obx(() {
      if (_controller.isLoading.value && _controller.posts.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: TColors.primary,
            strokeWidth: 3,
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _controller.posts.length + 1,
        itemBuilder: (context, index) {
          if (index == _controller.posts.length) {
            return _controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: TColors.primary,
                      strokeWidth: 3,
                    ),
                  )
                : const SizedBox.shrink();
          }

          final post = _controller.posts[index];
          return _buildPostCard(post, context);
        },
      );
    });
  }

  Widget _buildPostCard(PostModel post, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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

  // Update the _buildPostContent method in CommunityFeedPage
  Widget _buildPostContent(PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Support for multiple media types
        if (post.mediaUrls != null && post.mediaUrls!.isNotEmpty)
          MediaCarouselWidget(mediaUrls: post.mediaUrls!),

        if (post.content != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${post.userName} ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: ReadMoreText(
                    post.content!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    trimLines: 1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' more',
                    trimExpandedText: 'show less',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget _buildMediaContent(PostModel post) {
  //   // Determine if it's a video or image
  //   final isVideo = _isVideoUrl(post.mediaUrls!.first);
  //
  //   return isVideo
  //       ? _buildVideoPlayer(post.mediaUrls!.first)
  //       : _buildImagePost(post.mediaUrls!.first);
  // }

  // bool _isVideoUrl(String url) {
  //   // Add logic to check video URL
  //   return url.contains('.mp4') || url.contains('.mov');
  // }
  //
  // Widget _buildVideoPlayer(String videoUrl) {
  //   return VideoPlayerWidget(videoUrl: videoUrl);
  // }
  //
  // Widget _buildImagePost(String imageUrl) {
  //   return CachedNetworkImage(
  //     imageUrl: imageUrl,
  //     fit: BoxFit.cover,
  //     width: double.infinity,
  //     placeholder: (context, url) => Center(
  //       child: CircularProgressIndicator(
  //         color: TColors.primary,
  //       ),
  //     ),
  //     errorWidget: (context, url, error) => Icon(Icons.error),
  //   );
  // }

  Widget _buildPostHeader(PostModel post, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(post.userAvatar),
      ),
      title: Text(
        post.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        _formatDateTime(post.createdAt),
        style: const TextStyle(fontSize: 12),
      ),
      // trailing: IconButton(
      //   icon: const Icon(Icons.more_vert),
      //   onPressed: () {},
      // ),
    );
  }

  Widget _buildPostFooter(PostModel post) {
    return PostFooter(
      post: post,
      controller: _controller,
    );
  }

  void _showCategoryFilter() {
    // Implement category filter bottom sheet
    Get.bottomSheet(
      CategoryFilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildCreatePostButton() {
    return FloatingActionButton(
      onPressed: _showCreatePostBottomSheet,
      backgroundColor: TColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreatePostBottomSheet() {
    Get.bottomSheet(
      PostCreationBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
