import 'package:conquest/utils/constants/colors.dart';
import 'package:conquest/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TAppBar extends StatelessWidget {
  const TAppBar(
      {super.key,
      this.title,
      required this.showBackArrow,
      this.leadingIcon,
      this.actions,
      this.leading0nPressed});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leading0nPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
          automaticallyImplyLeading: false,
          leading: showBackArrow
              ? IconButton(
                  onPressed: () => Navigator.pop,
                  icon: const Icon(
                    Iconsax.arrow_left,
                    color: TColors.dark,
                  ))
              : leadingIcon != null
                  ? IconButton(
                      onPressed: leading0nPressed, icon: Icon(leadingIcon))
                  : null,
      title: title,
        actions: actions,
      ),
    );
  }
}
