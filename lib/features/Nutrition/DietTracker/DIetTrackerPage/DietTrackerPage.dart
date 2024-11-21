import 'package:conquest/features/Nutrition/DietTracker/DIetTrackerPage/widgets/TrackedDietWidget.dart';
import 'package:conquest/features/Nutrition/DietTracker/DIetTrackerPage/widgets/TrackingMealCard/TrackingMealListCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class DietTrackerPage extends StatelessWidget {
  const DietTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: Text('Calorie Counter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.spaceBtwItems / 1.5),
          child: Column(
            children: [
              TrackedDietWidget(),
              SizedBox(height: TSizes.spaceBtwSections / 1.5),
              TrackingMealListCard(),
            ],
          ),
        ),
      ),
    );
  }
}
