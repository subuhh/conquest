import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/features/Community/Post/Post_Creation/media_selection_screen.dart';
import 'package:conquest/features/Community/Profile/user_community_profile.dart';
import 'package:conquest/features/Community/comm_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';

class CommunityBtmNavBar extends StatelessWidget {
  const CommunityBtmNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        CommunityFeedPage(),
        MediaPickerScreen(),
        CommunityProfileScreen(
          userId: AuthService.instance.currentUser!.uid,
          wantBack: false,
        ),
      ];
    }

    Widget userIcon(bool active) {
      return Obx(() {
        final userController = UserController.instance.userModel.value;

        if (userController != null) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: active
                  ? Border.all(color: Colors.black, width: 2.0)
                  : Border.all(color: Colors.transparent, width: 0.0),
            ),
            child: CircleAvatar(
              backgroundImage: userController.profileImageUrl != null &&
                      userController.profileImageUrl!.isNotEmpty
                  ? NetworkImage(userController.profileImageUrl!)
                  : null,
              radius: 16.5,
              child: userController.profileImageUrl == null ||
                      userController.profileImageUrl!.isEmpty
                  ? Icon(Icons.person, size: 20)
                  : null,
            ),
          );
        } else {
          return Icon(active ? Icons.person : Icons.person_outline, size: 20);
        }
      });
    }

    Widget customIcon(Widget icon) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: icon),
        ),
      );
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          inactiveIcon: customIcon(Icon(Icons.home_outlined)),
          icon: customIcon(Icon(Icons.home)),
          inactiveColorPrimary: Colors.black.withOpacity(0.7),
          activeColorPrimary: Colors.black,
          iconSize: 34,
        ),
        PersistentBottomNavBarItem(
          icon: customIcon(
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColors.communityPrimary,
                    TColors.communitySecondary
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          inactiveColorPrimary: Colors.black.withOpacity(0.7),
          activeColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: customIcon(userIcon(false)),
          icon: customIcon(userIcon(true)),
          inactiveColorPrimary: Colors.black.withOpacity(0.7),
          activeColorPrimary: Colors.black,
        ),
      ];
    }

    return PersistentTabView(context,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: kBottomNavigationBarHeight,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: const Border(
            top: BorderSide(color: Colors.grey),
          ),
          colorBehindNavBar: Colors.white,
        ),
        navBarStyle: NavBarStyle.simple);
  }
}
