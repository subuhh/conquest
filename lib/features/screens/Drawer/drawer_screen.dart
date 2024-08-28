import 'dart:io';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/widgets/custom_list_tile_group.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Widget _buildProfileHeader(BuildContext context) {
    return StreamBuilder(
      stream: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // User is logged in, fetch user details from Firestore
          return FutureBuilder(
            future: null,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                // Show shimmer while fetching user details
                return _buildDrawerHeaderShimmer();
              } else if (userSnapshot.hasError) {
                // Show error message
                return ListTile(
                  title: Text('Error: ${userSnapshot.error}'),
                );
              } else {
                final userModel = userSnapshot.data;
                return _buildLoggedInHeader(context);
              }
            },
          );
        } else {
          // User is not logged in, show login button
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDrawerHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity, // Adjust width as needed
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

  Widget _buildLoggedInHeader(BuildContext context) {
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
          // if (_userModel != null) ...[
          const CircleAvatar(
            radius: 35,
            backgroundColor: TColors.grey,
            child: Text(
              'C',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          // ] else ...[
          //   CircleAvatar(
          //     radius: 35,
          //     backgroundColor: TColors.primaryBackground,
          //     child: Text(
          //       'G',
          //       style: Theme.of(context).textTheme.headlineLarge,
          //     ),
          //   ),
          // ],
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey, ConQuest',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'xyz@gmail.com',
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
                      _buildLoggedInHeader(context),
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
                          () {
                            Navigator.pushNamed(context, '/yourprofile');
                          },
                          'assets/icons/drawerIcons/profile.svg',
                          context,
                        ),
                        // ] else ...[
                        //   menuListTile(
                        //     'Login',
                        //         () {
                        //       Navigator.pushNamedAndRemoveUntil(
                        //         context,
                        //         '/login',
                        //             (Route<dynamic> route) => false,
                        //       );
                        //     },
                        //     'assets/icons/categories/login.svg',
                        //   )
                        // ]
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      tiles: [
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomListTileGroup(
                      header: 'Discover', // Optional header
                      tiles: [
                        menuListTile(
                          'Home',
                          () => Navigator.of(context).pushNamed('/home'),
                          'assets/icons/drawerIcons/home.svg',
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
                          () => Navigator.of(context).pushNamed('/feedback'),
                          'assets/icons/drawerIcons/feedback.svg',
                          context,
                        ),
                        menuListTile(
                          'FAQ',
                          () => Navigator.of(context).pushNamed('/faq'),
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
                          () => Navigator.of(context).pushNamed('/aboutus'),
                          'assets/icons/drawerIcons/about_us.svg',
                          context,
                        ),
                        menuListTile(
                          'Privacy & Policy',
                          () => Navigator.of(context).pushNamed('/privacy'),
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
                            () => Navigator.of(context).pushNamed('/settings'),
                            'assets/icons/drawerIcons/settings.svg',
                            context,
                          ),
                          menuListTile(
                            'Invite Friends',
                            () => Navigator.of(context).pushNamed('/invite'),
                            'assets/icons/drawerIcons/invite.svg',
                            context,
                          ),
                          // if (_auth.currentUser != null) ...[
                          menuListTile(
                            'Log Out',
                            () {},
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
