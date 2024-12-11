import 'package:conquest/features/Community/comm_feed_screen.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class CommunityBottomNavBar extends StatefulWidget {
  const CommunityBottomNavBar({super.key});

  @override
  State<CommunityBottomNavBar> createState() => _CommunityBottomNavBarState();
}

class _CommunityBottomNavBarState extends State<CommunityBottomNavBar> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          CommunityFeedPage(),
          Center(child: Text('Contact Page')),
          Center(child: Text('Add Page')),
          Center(child: Text('Work Page')),
          Center(child: Text('Holiday Page')),
        ],
      ),
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(Icons.home, 0, 'homeNavHero'),
            buildNavItem(Icons.contact_emergency, 1, 'contactNavHero'),
            buildCenterNavItem('addNavHero'),
            buildNavItem(Icons.work_off, 3, 'workNavHero'),
            buildNavItem(Icons.holiday_village, 4, 'holidayNavHero'),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, int index, String tag) {
    bool isSelected = index == selectedIndex;
    return Hero(
      tag: tag, // Unique tag for each navigation item
      child: IconButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
          pageController.jumpToPage(index); // Jump to the selected page
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.black : Color(0xffb5b7bf),
          size: 32,
        ),
      ),
    );
  }

  Widget buildCenterNavItem(String tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = 2;
        });
        pageController.jumpToPage(2); // Jump to the "Add" page
      },
      child: Hero(
        tag: tag, // Unique tag for the center icon
        child: Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [TColors.communityPrimary, TColors.communitySecondary],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
