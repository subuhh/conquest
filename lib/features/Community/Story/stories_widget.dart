import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/Controllers/community_controller/stories_controller.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Community/Post/Post_Creation/media_selection_screen.dart';
import 'package:conquest/features/Community/Story/story_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/model/community/stories_model.dart';
import '../../../utils/constants/colors.dart';

class StoriesWidget extends StatelessWidget {
  final bool forCurrentUser;
  StoriesWidget({
    super.key,
    this.forCurrentUser = false,
  });

  final storiesController = StoriesController.instance;
  final currentUserId = AuthService.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              storiesController.currentUserStories.isNotEmpty
                  ? buildStoriesWidget(
                      h, w, storiesController.currentUserStories, context,
                      isCurrentUser: true)
                  : addStories(h, w),
              if (!forCurrentUser) ...[
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    storiesController.followedUsersStories.length,
                    (index) {
                      final userStories =
                          storiesController.followedUsersStories[index];
                      return buildStoriesWidget(h, w, userStories, context,
                          isCurrentUser: false);
                    },
                  ),
                )
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget addStories(double h, double w) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MediaPickerScreen(pickerMode: MediaPickerMode.story));
      },
      child: Container(
        height: h * 0.12,
        width: w * 0.2,
        decoration: BoxDecoration(
          color: Color(0xffD3D5DC),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColors.communityPrimary, TColors.communitySecondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                )
              ],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStoriesWidget(
    double h,
    double w,
    List<StoryModel> stories,
    BuildContext context, {
    bool isCurrentUser = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to full-screen story viewer
        Get.to(() => StoryViewerScreen(stories: stories));
      },
      onLongPress: () {
        _showCustomBottomSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Container(
              height: h * 0.12,
              width: w * 0.2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                image: stories.first.mediaType == StoryMediaType.image
                    ? DecorationImage(
                        image:
                            CachedNetworkImageProvider(stories.first.mediaUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: stories.first.mediaType == StoryMediaType.video
                  ? Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : null,
            ),
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset:
                    Offset(w * 0.07, h * 0.102), // Move the circle half outside
                child: Container(
                  height: h * 0.03,
                  width: h * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      )
                    ],
                    image: stories.first.userAvatar != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                                stories.first.userAvatar!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomBottomSheet(BuildContext context) {
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
                  "Add Story",
                  Icons.report,
                  Colors.black,
                  () {
                    Get.back();
                    Get.to(() =>
                        MediaPickerScreen(pickerMode: MediaPickerMode.story));
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }
}
