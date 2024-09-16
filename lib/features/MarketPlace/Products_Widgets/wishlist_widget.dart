import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class WishListButton extends StatelessWidget {
  final bool isDecoration;

  const WishListButton({super.key, this.isDecoration = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDecoration ? 35 : null,
      decoration: isDecoration
          ? BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            )
          : null,
      child: Center(
        child: IconButton(
          icon: Icon(
            Iconsax.heart,
            color: isDecoration ? Colors.black : Colors.white,
            size: isDecoration ? 20 : null,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
