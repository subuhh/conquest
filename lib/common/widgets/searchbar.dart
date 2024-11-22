import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/sizes.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwInputFields / 1.5, horizontal: 10),
      child: Container(
        height: 50.0, // Adjust the height as needed
        decoration: BoxDecoration(
          border: Border.all(color: TColors.white),
          color: Colors.grey[200], // Light grey background
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.grey, // Grey text color
              fontSize: 16.0, // Adjust the font size as needed
            ),
            prefixIcon: Icon(
              Iconsax.search_normal,
              color: Colors.grey, // Grey icon color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // Customize focused border
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(top: 15.0), // Align the text vertically
          ),
        ),
      ),
    );
  }
}
