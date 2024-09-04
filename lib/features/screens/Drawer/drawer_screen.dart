import 'dart:io';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Authentication/login/login.dart';
import 'package:conquest/features/screens/Drawer/Header.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/custom_list_tile_group.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    const double uniformPadding = 8.0;
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      buildLoggedInHeader(context),
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
                        // if (_auth.currentUser != null) ...[
                        menuListTile(
                          'Your Profile',
                          () {},
                          'assets/icons/drawerIcons/profile.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // My Orders Group
                    CustomListTileGroup(
                      tiles: [
                        menuListTile(
                          'My Orders',
                          () {},
                          'assets/icons/drawerIcons/my_order.svg',
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Discover', // Optional header
                      tiles: [
                        menuListTile(
                          'Home',
                          () => Navigator.of(context).pushNamed('/btmnav'),
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
                    // Community Group
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Community', // Optional header
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
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Support', // Optional header
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
                      header: 'Legal & About', // Optional header
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
                        header: 'More', // Optional header
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
                                // await launchUrl(
                                //   Uri.parse(
                                //       "https://play.google.com/store/apps/details?id=com.yourapp.id"),
                                // );
                              } else if (Platform.isIOS) {
                                // await launchUrl(
                                //   Uri.parse(
                                //       "https://apps.apple.com/app/idYOUR_APP_ID"),
                                // );
                              }
                            },
                            'assets/icons/drawerIcons/rate_us.svg',
                            context,
                          ),
                          // if (_auth.currentUser != null) ...[
                          menuListTile(
                            'Log Out',
                            () {
                              _auth.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            'assets/icons/drawerIcons/logout.svg',
                            context,
                          ),
                        ]
                        // ],
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
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
