import 'package:conquest/features/Nutrition/NutritionHomePage.dart';
import 'package:conquest/features/Wokrout/WorkoutHomepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/colors.dart'; // Make sure to import your constants
import 'package:conquest/features/HomePage/homepage.dart';
import 'package:conquest/features/MarketPlace/market_place_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // Keep track of the selected tab

  final inActiveIconList = <String>[
    'assets/icons/bottomNavbaricons/InactiveIcons/home.svg',
    'assets/icons/bottomNavbaricons/InactiveIcons/workout.svg',
    'assets/icons/appicons/nutrition-outline.svg',
    'assets/icons/drawerIcons/community.svg',
    'assets/icons/bottomNavbaricons/InactiveIcons/shop.svg',

  ];

  final activeIconList = <String>[
    'assets/icons/bottomNavbaricons/activeIcons/home.svg',
    'assets/icons/bottomNavbaricons/activeIcons/workout.svg',
    'assets/icons/appicons/nutrition-outline.svg',
    'assets/icons/drawerIcons/community.svg',
    'assets/icons/bottomNavbaricons/activeIcons/shop.svg',

   // 'assets/icons/bottomNavbaricons/activeIcons/settings.svg',
  ];

  final itemLabel = <String>[
    'Home',
    'Workouts',
    'Nutrition',
    'Community',
    'Shop',

    //'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              HomePage(),
              Workouthomepage(),
              NutritionHomePage(),
              Center(child: Text('Community')),
              MarketplaceScreen(),
            ],
          ),
          // CurvedNavigationBar
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedNavigationBar(
              index: _currentIndex,
              height: 70.0,
              backgroundColor: Colors.transparent, // Transparent behind the curve
              color: Colors.black,
              buttonBackgroundColor: TColors.primary, // The primary color
              items: List.generate(inActiveIconList.length, (index) {
                return _currentIndex == index?Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    activeIconList[index],
                    width: 25,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                       Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      inActiveIconList[index],
                      width: 25,
                      height: 25,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(itemLabel[index],style: TextStyle(color: Colors.white,fontSize: 12),)
                  ],
                );
              }),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}
