import 'dart:io';
import 'package:conquest/core/Controllers/drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/widgets/custom_list_tile_group.dart';
import '../../../core/model/user.dart';
import '../../../core/services/auth_service.dart';
import '../Address/address_saved_screen.dart';
import '../utils/constants/colors.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  // Instance of GetX Controller
  final DrawerMenuController drawerController = Get.put(DrawerMenuController());

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Obx(() {
        if (drawerController.isLoading.value) {
          // Show shimmer while loading user details
          return _buildDrawerHeaderShimmer();
        }

        // Display profile details after data is loaded
        final userModel = drawerController.userModel.value;
        return buildLoggedInHeader(context, userModel);
      }),
    );
  }

  Widget buildLoggedInHeader(BuildContext context, UserModel? userModel) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding:
          const EdgeInsets.only(top: 24.0, left: 16, bottom: 24, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: TColors.primary.withOpacity(0.9),
            child: Text(
              userModel?.name[0].toUpperCase() ?? 'G',
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel?.name ?? '',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  userModel?.email ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.4),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(2.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              height: 40.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 120.0,
              height: 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 4.0),
            Container(
              width: 180.0,
              height: 16.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double uniformPadding = 8.0;
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 190,
                maxHeight: 190,
                child: Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                      _buildProfileHeader(context),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(uniformPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CustomListTileGroup(
                      tiles: [
                        menuListTile(
                          'Your Profile',
                          () => Get.toNamed('/profileScreen'),
                          'assets/icons/drawerIcons/profile.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          // Make sure each ListTile takes up half the available width
                          child: CustomListTileGroup(
                            tiles: [
                              menuListTile(
                                'Orders',
                                () {},
                                'assets/icons/drawerIcons/my_order.svg',
                                context,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CustomListTileGroup(
                            tiles: [
                              menuListTile(
                                'Address',
                                () => Get.to(const SavedAddress()),
                                'assets/icons/drawerIcons/address.svg',
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Discover',
                      tiles: [
                        menuListTile(
                          'Home',
                          () => Get.toNamed('/btmnav'),
                          'assets/icons/drawerIcons/home.svg',
                          context,
                        ),
                        menuListTile(
                          'Workout Plan',
                          () {},
                          'assets/icons/drawerIcons/workout.svg',
                          context,
                        ),
                        menuListTile(
                          'Nutrition Guide',
                          () {},
                          'assets/icons/drawerIcons/nutrition.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Community',
                      tiles: [
                        menuListTile(
                          'Nakama Community',
                          () {},
                          'assets/icons/drawerIcons/community.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Engage & Compete',
                      tiles: [
                        menuListTile(
                          'Daily Challenges',
                          () {},
                          'assets/icons/drawerIcons/daily_challenges.svg',
                          context,
                        ),
                        menuListTile(
                          'Leaderboards',
                          () {},
                          'assets/icons/drawerIcons/leaderboard.svg',
                          context,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 20),
                    // CustomListTileGroup(
                    //   header: 'Account Settings',
                    //   tiles: [
                    //     menuListTile(
                    //       'Orders',
                    //       () {
                    //         Get.to(() => const MyOrdersScreen());
                    //       },
                    //       'assets/icons/drawerIcons/my_order.svg',
                    //       context,
                    //     ),
                    //     menuListTile(
                    //       'WishList',
                    //       () {},
                    //       'assets/icons/drawerIcons/faq.svg',
                    //       context,
                    //     ),
                    //     menuListTile(
                    //       'Address Book',
                    //       () {},
                    //       'assets/icons/drawerIcons/faq.svg',
                    //       context,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Support',
                      tiles: [
                        menuListTile(
                          'Feedback',
                          () {},
                          'assets/icons/drawerIcons/feedback.svg',
                          context,
                        ),
                        menuListTile(
                          'FAQ',
                          () {},
                          'assets/icons/drawerIcons/faq.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Legal & About',
                      tiles: [
                        menuListTile(
                          'About',
                          () {},
                          'assets/icons/drawerIcons/about_us.svg',
                          context,
                        ),
                        menuListTile(
                          'Privacy & Policy',
                          () {},
                          'assets/icons/drawerIcons/privacy_policy.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'More',
                      tiles: [
                        menuListTile(
                          'Settings',
                          () {},
                          'assets/icons/drawerIcons/settings.svg',
                          context,
                        ),
                        menuListTile(
                          'Invite Friends',
                          () {},
                          'assets/icons/drawerIcons/invite.svg',
                          context,
                        ),
                        menuListTile(
                          'Rate Us',
                          () async {
                            if (Platform.isAndroid) {
                              // Handle Play Store link
                            } else if (Platform.isIOS) {
                              // Handle App Store link
                            }
                          },
                          'assets/icons/drawerIcons/rate_us.svg',
                          context,
                        ),
                        menuListTile(
                          'Log Out',
                          () {
                            Get.find<AuthService>().signOut();
                            Get.offAllNamed('/login');
                          },
                          'assets/icons/drawerIcons/logout.svg',
                          context,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
