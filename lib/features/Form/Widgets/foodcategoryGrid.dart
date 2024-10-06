import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/colors.dart';

class FoodCategoryGrid extends StatefulWidget {
  @override
  _FoodCategoryGridState createState() => _FoodCategoryGridState();
}

class _FoodCategoryGridState extends State<FoodCategoryGrid> {
  final List<Map<String, dynamic>> foodCategories = [
    {
      'icon': 'assets/icons/FoodCategory/NonVeg.svg',
      'label': 'Non-veg'
    },
    {'icon': 'assets/icons/FoodCategory/Poultry.svg',
      'label': 'Poultry'},
    {
      'icon': 'assets/icons/FoodCategory/Vegeterian.svg',
      'label': 'Vegeterian'
    },
    {
      'icon': 'assets/icons/FoodCategory/vegan.svg',
      'label': 'Vegan'
    },
  ];

  // List to keep track of selected items
  List<bool> isSelectedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selection state for each category
    isSelectedList = List<bool>.filled(foodCategories.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.2,
        ),
        padding: const EdgeInsets.all(15.0),
        itemCount: foodCategories.length,
        itemBuilder: (context, index) {
          final category = foodCategories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                // Toggle the selection state on tap
                isSelectedList[index] = !isSelectedList[index];
              });
            },
            child: FoodCategoryCard(
              iconUrl: category['icon'],
              label: category['label'],
              isSelected: isSelectedList[index], // Use the selection state
            ),
          );
        },
      ),
    );
  }
}

class FoodCategoryCard extends StatelessWidget {
  final String iconUrl;
  final String label;
  final bool isSelected;

  const FoodCategoryCard({
    Key? key,
    required this.iconUrl,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0, // Adjust the elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16.0), // Same borderRadius as before
      ),
      color: isSelected ? TColors.primary : Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            height: 40,
            colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.black, BlendMode.srcIn),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
