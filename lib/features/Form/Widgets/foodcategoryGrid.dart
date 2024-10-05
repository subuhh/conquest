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
      'icon': 'https://www.svgrepo.com/show/427742/meat.svg',
      'label': 'Non-veg'
    },
    {'icon': 'https://www.svgrepo.com/show/410224/egg.svg', 'label': 'Poultry'},
    {
      'icon': 'https://www.svgrepo.com/show/427751/cheese-wedge.svg',
      'label': 'Vegeterian'
    },
    {
      'icon': 'https://www.svgrepo.com/show/447186/smoothie-organic.svg',
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2,
      ),
      padding: const EdgeInsets.all(16.0),
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
      elevation: 5.0, // Adjust the elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16.0), // Same borderRadius as before
      ),
      color: isSelected ? TColors.primary : Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(
            iconUrl,
            height: 40,
            colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.black, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
