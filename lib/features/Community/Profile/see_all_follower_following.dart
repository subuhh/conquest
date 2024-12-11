import 'package:conquest/core/Controllers/community_controller/followers_controller.dart';
import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Community/Profile/user_community_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeAllFollowerFollowing extends StatefulWidget {
  final UserModel user;
  final bool isFollower;

  const SeeAllFollowerFollowing(
      {super.key, required this.user, required this.isFollower});

  @override
  _SeeAllFollowerFollowingState createState() =>
      _SeeAllFollowerFollowingState();
}

class _SeeAllFollowerFollowingState extends State<SeeAllFollowerFollowing>
    with SingleTickerProviderStateMixin {
  final followController = FollowController.instance;
  final currentUserId = AuthService.instance.currentUser!.uid;

  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<UserModel> filteredFollowers = [];
  List<UserModel> filteredFollowing = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isFollower ? 0 : 1,
    );
    _searchController.addListener(_filterLists);
    fetchFollowersAndFollowing();
  }

  void _filterLists() {
    setState(() {
      if (_tabController.index == 0) {
        filteredFollowers = followController.followers
            .where((follower) => follower.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

        filteredFollowing = followController.following
            .where((follow) => follow.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        filteredFollowing = followController.following
            .where((follow) => follow.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

        filteredFollowers = followController.followers
            .where((follower) => follower.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> fetchFollowersAndFollowing() async {
    await followController.fetchFollowers(widget.user.id);
    await followController.fetchFollowing(widget.user.id);
    _filterLists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.userName, style: GoogleFonts.poppins()),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          dividerColor: Colors.grey[100],
          tabs: [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Obx(() {
                  if (followController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (followController.followers.isEmpty) {
                    return _buildEmptyView('No followers found', Icons.person);
                  } else {
                    return _buildListView(filteredFollowers);
                  }
                }),
                Obx(() {
                  if (followController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (followController.following.isEmpty) {
                    return _buildEmptyView('No following found', Icons.person);
                  } else {
                    return _buildListView(filteredFollowing);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<UserModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final user = items[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
            backgroundColor: Colors.grey[200],
          ),
          title: Text(user.name, style: GoogleFonts.poppins()),
          subtitle: Text(user.userName, style: GoogleFonts.poppins()),
          trailing: currentUserId == widget.user.id
              ? Obx(() {
                  final isFollowing =
                      followController.followStatus.containsKey(user.id) &&
                          followController.followStatus[user.id]!.value;

                  return ElevatedButton(
                    onPressed: () {
                      followController.toggleFollow(user.id);
                    },
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        backgroundColor:
                            isFollowing ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.black)),
                    child: Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                          color: isFollowing ? Colors.black : Colors.white),
                    ),
                  );
                })
              : null,
          onTap: () {
            Get.to(
              () => CommunityProfileScreen(userId: user.id, wantBack: true),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyView(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(message,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
