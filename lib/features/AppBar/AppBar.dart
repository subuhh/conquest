import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor ;
  final List<Widget>? actions;
  final double left;
  final double? right;

  CustomAppBar({
    this.backgroundColor = Colors.white,
    this.actions, required this.left, this.right = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/drawer');
        },
        icon: const Icon(
          Icons.menu,
          size: TSizes.iconLg,
        ),
      ),
      centerTitle: true,
      title:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: left,right: right ?? 0),
            child: Image.asset(
              'assets/logos/ConQuest Top Bar Logo.png',
              height: TSizes.iconLg + 15,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }
}