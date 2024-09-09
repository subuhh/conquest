import 'dart:developer';
import 'dart:io';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Authentication/GenderSelection/GenderSelectionPage.dart';
import 'package:conquest/features/Authentication/login/login.dart';
import 'package:conquest/features/screens/MarketPlace/Products/OrderHIstory/MyOrders.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/widgets/custom_list_tile_group.dart';
import '../../../core/model/user.dart';
import '../../../core/services/firestore_service.dart';
import '../../utils/constants/colors.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _auth = AuthService();
  bool _isLoading = true;
  UserModel? _userModel;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = _auth.user;

    try {
      final userData = await user.first;
      if (userData != null) {
        // Check if userData is not null
        _userModel = await _firestoreService.getUserDetails(userData.uid);
      }
    } catch (e) {
      // Handle errors here (e.g., show error message)
      log('Error fetching user details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileHeader(BuildContext context) {
    final user = _auth.user;
    return Container(
      color: Colors.white,
      child: StreamBuilder<User?>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is logged in, fetch user details from Firestore
            return FutureBuilder<UserModel?>(
              future: FirestoreService().getUserDetails(snapshot.data!.uid),
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
                  return buildLoggedInHeader(context, userModel);
                }
              },
            );
          } else {
            // User is not logged in, show login button
            return const SizedBox.shrink();
          }
        },
      ),
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
          if (_userModel != null) ...[
            CircleAvatar(
              radius: 35,
              backgroundColor: TColors.primary.withOpacity(0.9),
              child: Text(
                userModel?.name[0].toUpperCase() ?? '',
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ] else ...[
            CircleAvatar(
              radius: 35,
              backgroundColor: TColors.primaryBackground,
              child: Text(
                'G',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ],
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
                        // if (_auth.currentUser != null) ...[
                        menuListTile(
                          'Your Profile',
                          () =>
                              Navigator.of(context).pushNamed('/profileScreen'),
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
                          () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyOrdersScreen()));
                          },
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
                          () {
                            THelperFunctions.navigateToScreen(context, GenderSelectionScreen());
                          },
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
