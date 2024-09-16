import 'package:conquest/features/BottomNavBar/src/models/bottom_bar_item_model.dart';
import 'package:conquest/features/BottomNavBar/src/notch_bottom_bar.dart';
import 'package:conquest/features/BottomNavBar/src/notch_bottom_bar_controller.dart';

import 'package:conquest/features/HomePage/homepage.dart';
import 'package:conquest/features/MarketPlace/market_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _notchBottomBarController = NotchBottomBarController();
  final PageController _pageController = PageController();

  final inActiveIconList = <String>[
    'assets/icons/bottomNavbaricons/InactiveIcons/home.svg',
    'assets/icons/bottomNavbaricons/InactiveIcons/shop.svg',
    'assets/icons/bottomNavbaricons/InactiveIcons/workout.svg',
    'assets/icons/bottomNavbaricons/InactiveIcons/settings.svg',
  ];
  final activeIconList = <String>[
    'assets/icons/bottomNavbaricons/activeIcons/home.svg',
    'assets/icons/bottomNavbaricons/activeIcons/shop.svg',
    'assets/icons/bottomNavbaricons/activeIcons/workout.svg',
    'assets/icons/bottomNavbaricons/activeIcons/settings.svg',
  ];
  final itemLabel = <String>[
    'Home',
    'Shop',
    'Workouts',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _notchBottomBarController
                  .jumpTo(index); // Sync page index with NotchBottomBar
            },
            children: const [
              HomePage(),
              MarketplaceScreen(),
              Center(child: Text('Workout Tracking')),
              Center(child: Text('Settings page')),
            ],
          ),
          Positioned(
            bottom: 0,
            child: AnimatedNotchBottomBar(
              color: Colors.black,
              notchBottomBarController: _notchBottomBarController,
              bottomBarItems: List.generate(inActiveIconList.length, (index) {
                return BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    inActiveIconList[index],
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                  activeItem: SvgPicture.asset(
                    clipBehavior: Clip.hardEdge,
                    activeIconList[index],
                    colorFilter: const ColorFilter.mode(
                        TColors.primary, BlendMode.srcIn),
                    // Active color of the icon
                  ),
                  itemLabel: itemLabel[index], // Label for each item
                );
              }),
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                );
              },
              removeMargins: false,
              bottomBarHeight: 80,
              bottomBarWidth: MediaQuery.of(context).size.width,
              durationInMilliSeconds: 50,
              notchColor: Colors.white,
              showLabel: true,
              itemLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              //elevation: 100.0,
              kIconSize: 25,
              kBottomRadius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
