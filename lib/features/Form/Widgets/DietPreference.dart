import 'package:conquest/core/Controllers/Form_Controller/FormController.dart';
import 'package:conquest/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../utils/constants/colors.dart';

class DietPreference extends StatefulWidget {
  @override
  _DietPreferenceState createState() => _DietPreferenceState();
}

class _DietPreferenceState extends State<DietPreference> {
  final controller = FormController.instance;

  final List<Map<String, dynamic>> foodCategories = [
    {
      'icon': 'assets/icons/FoodCategory/Vegeterian.svg',
      'label': 'Vegetarian',
      'subtitle': 'Plant-based but may include dairy and eggs.'
    },
    {
      'icon': 'assets/icons/FoodCategory/Poultry.svg',
      'label': 'Vegan',
      'subtitle': 'For those who avoid all animal products.'
    },
    {
      'icon': 'assets/icons/FoodCategory/NonVeg.svg',
      'label': 'Non-veg',
      'subtitle': 'Includes all types of animal products.'
    },
    {
      'icon': 'assets/icons/FoodCategory/vegan.svg',
      'label': 'Dairy-Free',
      'subtitle': 'For those with lactose intolerance or dairy restrictions.'
    },
    {
      'icon': 'assets/icons/FoodCategory/vegan.svg',
      'label': 'Keto',
      'subtitle': 'A low-carb, high-fat diet popular among fitness enthusiasts.'
    },
    {
      'icon': 'assets/icons/FoodCategory/Vegeterian.svg',
      'label': 'Gluten-Free',
      'subtitle': 'For individuals with celiac disease or gluten sensitivity.'
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
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 1.4,
        ),
        padding: const EdgeInsets.all(15.0),
        itemCount: foodCategories.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = foodCategories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                // Toggle the selection state on tap
                if (controller.selectedDietPreferences
                    .contains(category['label'])) {
                  controller.selectedDietPreferences.remove(category['label']);
                } else {
                  if (controller.selectedDietPreferences.length < 2) {
                    controller.selectedDietPreferences.add(category['label']);
                  } else {
                    // Show a snack bar or a dialog to inform the user
                    TLoaders.errorSnackBar(
                      title: 'You can only select up to 2 diet preferences.',
                    );
                  }
                }
              });
            },
            child: Obx(
              () => FoodCategoryCard(
                iconUrl: category['icon'],
                label: category['label'],
                subtitle: category['subtitle'],
                isSelected: controller.selectedDietPreferences.contains(
                  category['label'],
                ), // Use the selection state
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget FoodCategoryCard({
  required String iconUrl,
  required String label,
  required String subtitle,
  required bool isSelected,
}) {
  return Card(
    elevation: 1.0, // Adjust the elevation as needed
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Same borderRadius as before
    ),
    color: isSelected ? TColors.primary : Colors.grey[200],
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            height: 32,
            colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.black, BlendMode.srcIn),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
