import 'dart:developer';
import 'package:conquest/core/Controllers/community_controller/community_controller.dart';
import 'package:conquest/core/Controllers/community_controller/followers_controller.dart';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Community/Profile/see_all_follower_following.dart';
import 'package:conquest/features/Community/Profile/see_all_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/model/community/post_model.dart';
import '../widgets/enlarge_image.dart';
import 'community_profile_edit.dart';

class CommunityProfileScreen extends StatefulWidget {
  final String userId;
  final bool wantBack;

  const CommunityProfileScreen({
    super.key,
    required this.userId,
    this.wantBack = true,
  });

  @override
  _CommunityProfileScreenState createState() => _CommunityProfileScreenState();
}

class _CommunityProfileScreenState extends State<CommunityProfileScreen> {
  final currentUserId = AuthService.instance.currentUser!.uid;
  final communityController = CommunityController.instance;
  final followerController = FollowController.instance;

  bool currentUser = false;
  bool isLoading = false;

  late Stream<UserModel?> _userFuture;

  List<PostModel>? posts;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userId == currentUserId;
    fetchPost();
    // Initialize the future in initState to avoid setState during build
    _userFuture = UserController.instance.getUserDetailStream(widget.userId);
  }

  Future<void> fetchPost() async {
    setState(() => isLoading = true);
    posts = await communityController.fetchPostsByUserId(widget.userId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<UserModel?>(
        stream: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SafeArea(
                child: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return SafeArea(
              child: Center(
                child: Text('Error loading user', style: GoogleFonts.poppins()),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return SafeArea(
              child: Center(
                child: Text('No user data available',
                    style: GoogleFonts.poppins()),
              ),
            );
          }

          // Safe to use snapshot.data now
          final user = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // User Profile Banner
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            image: user.bannerImageUrl != null &&
                                    user.bannerImageUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(user.bannerImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: height * 0.25 / 2 - 15),
                                Text(
                                  user.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '@${user.userName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildStatsRow(user),
                                const SizedBox(height: 20),
                                _buildActionButtons(width, user),
                                const SizedBox(height: 20),
                                _buildPostsSection(height, width),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // User Profile Image
                    Positioned(
                      top: height * 0.25 - 110,
                      left: width * 0.5 - (width * 0.22),
                      child: GestureDetector(
                        onTap: user.profileImageUrl != null &&
                                user.profileImageUrl!.isNotEmpty
                            ? () {
                                EnlargeImage.showZoomableImage(
                                    user.profileImageUrl!, context);
                              }
                            : null,
                        child: Container(
                          height: height * 0.22,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 10),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: user.profileImageUrl != null &&
                                    user.profileImageUrl!.isNotEmpty
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                            child: user.profileImageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: height * 0.1,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),

                    // Back Button
                    if (widget.wantBack)
                      Positioned(
                        top: height * 0.06,
                        left: width * 0.05,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildStatColumn(
                'Posts',
                posts != null && posts!.isNotEmpty ? posts!.length : 0,
                false,
                user),
          ),
          Expanded(
            child: _buildStatColumn(
                'Followers', user.totalFollowers ?? 0, true, user),
          ),
          Expanded(
            child: _buildStatColumn(
                'Following', user.totalFollowing ?? 0, true, user),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      String label, int count, bool wantTap, UserModel user) {
    return GestureDetector(
      onTap: wantTap
          ? () {
              Get.to(() => SeeAllFollowerFollowing(
                    user: user,
                    isFollower: label == 'Followers' ? true : false,
                  ));
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5),
          Text(
            isLoading ? '' : '$count',
            style:
                GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(double width, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Row(
        children: [
          Obx(() {
            final isFollowing =
                followerController.followStatus.containsKey(user.id) &&
                    followerController.followStatus[user.id]!.value;
            return Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: () {
                  if (currentUser) {
                    Get.to(() => CommunityProfileEdit(userModel: user));
                  } else {
                    followerController.toggleFollow(user.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8),
                    ),
                    side: BorderSide(color: Colors.black, width: 2)),
                child: Text(
                  currentUser
                      ? 'Edit Profile'
                      : isFollowing
                          ? 'Following'
                          : 'Follow',
                  style: GoogleFonts.poppins(
                      color: isFollowing ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
          const SizedBox(width: 15),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              child: SvgPicture.asset(
                currentUser
                    ? 'assets/icons/appicons/share.svg'
                    : 'assets/icons/community/chat.svg',
                height: currentUser ? 35 : 30,
                width: currentUser ? 35 : 30,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isVideoUrl(String url) {
    return url.contains('.mp4') || url.contains('.mov');
  }

  Widget _buildPostsSection(double h, double w) {
    if (isLoading) {
      return _buildShimmerEffect(w);
    } else if (posts != null && posts!.isEmpty) {
      return Center(
          child: Text('No photos available', style: GoogleFonts.poppins()));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posts',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => SeeAllPosts(posts: posts!)),
                  child: Text(
                    'See all',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: w * 0.45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: posts!.length,
                itemBuilder: (context, index) {
                  final post = posts![index];
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: w * 0.45,
                    width: w * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      image: post.mediaUrls != null
                          ? _isVideoUrl(post.mediaUrls![0])
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(post.mediaUrls![0]),
                                  fit: BoxFit.cover,
                                )
                          : null,
                    ),
                    child: post.mediaUrls == null
                        ? Center(
                            child: Text(
                              'No Image',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildShimmerEffect(double w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: w * 0.45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: w * 0.45,
                    width: w * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
