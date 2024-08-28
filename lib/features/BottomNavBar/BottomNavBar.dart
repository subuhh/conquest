import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/HomePage/homepage.dart';
import '../utils/constants/sizes.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _bottomNavIndex = 0;

  final iconList = <String>[
    'assets/icons/appicons/home.svg',
    'assets/icons/appicons/cart.svg',
    'assets/icons/appicons/cardiogram.svg',
    'assets/icons/appicons/tools.svg',
  ];

  final List<Widget> _screens = [
    Homepage(),
    Center(child: Text('Screen 2')),
    Center(child: Text('Screen 3')),
    Center(child: Text('Screen 4')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_bottomNavIndex], // Displays the selected screen
      floatingActionButton: Container(
        height: TSizes.imageThumbSize-20,
        child: Image.asset('assets/logos/conquest-icon.png'),
        color: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.black : Colors.grey;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              iconList[index],
              color: color,
              height: 10, // Specify the size for each icon
            ),
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}