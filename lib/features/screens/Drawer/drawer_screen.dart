import 'dart:io';
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
                          () {
                            Navigator.pushNamed(context, '/yourprofile');
                          },
                          'assets/icons/drawerIcons/profile.svg',
                          context,
                        ),
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
