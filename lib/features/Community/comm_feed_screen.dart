import 'package:conquest/core/Controllers/community_controller/followers_controller.dart';
import 'package:conquest/core/Controllers/community_controller/stories_controller.dart';
import 'package:conquest/features/Community/Post/Post_Card/post_card_widget.dart';
import 'package:conquest/features/Community/Story/stories_widget.dart';
import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/Controllers/community_controller/community_controller.dart';
import '../../core/model/community/post_model.dart';
import 'Category_Filter/category_filter_bottom_sheet.dart';

class CommunityFeedPage extends StatelessWidget {
  final _controller = Get.put(CommunityController());
  final followersController = Get.put(FollowController());
  final storiesController = Get.put(StoriesController());

  CommunityFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            StoriesWidget(),
            const SizedBox(height: 20),
            _buildCategoryChips(),
            _buildPostList(),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
      automaticallyImplyLeading: false,
      title: Text(
        'Nakama',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Obx(() => Wrap(
              spacing: 10,
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
                      backgroundColor: Colors.grey[100],
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
          return PostCardWidget(post: post);
        },
      );
    });
  }

  void _showCategoryFilter() {
    // Implement category filter bottom sheet
    Get.bottomSheet(
      CategoryFilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
