import 'package:conquest/utils/constants/colors.dart';
import 'package:conquest/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/Controllers/Form_Controller/FormController.dart';

class HowMuchWeightScreen extends StatefulWidget {
  const HowMuchWeightScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HowMuchWeightScreenState createState() => _HowMuchWeightScreenState();
}

class _HowMuchWeightScreenState extends State<HowMuchWeightScreen> {
  final controller = FormController.instance;

  // // Default selected values
  // int selectedInteger = 60;
  // int selectedFraction = 5;
  // String selectedUnit = 'Kg'; // Kg or Lbs

  // Conversion methods
  double get weightInKg =>
      controller.currentWeightInteger.value +
      controller.currentWeightFraction.value / 10;
  double get weightInLbs => weightInKg * 2.20462;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buttons for selecting between Kg and Lbs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (controller.currentWeightUnit.value != 'Kg') {
                      controller.currentWeightUnit.value = 'Kg';
                      // Convert the current lbs value to kg
                      double weightInKg = weightInLbs / 2.20462;
                      controller.currentWeightInteger.value =
                          weightInKg.floor();
                      controller.currentWeightFraction.value = ((weightInKg -
                                  controller.currentWeightInteger.value) *
                              10)
                          .round();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.currentWeightUnit.value == 'Kg'
                      ? TColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  'Kg',
                  style: TextStyle(
                    color: controller.currentWeightUnit.value == 'Kg'
                        ? TColors.white
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (controller.currentWeightUnit.value != 'Lbs') {
                    controller.currentWeightUnit.value = 'Lbs';
                    // Convert the current kg value to lbs
                    double weightInLbs = weightInKg * 2.20462;
                    controller.currentWeightInteger.value = weightInLbs.floor();
                    controller.currentWeightFraction.value =
                        ((weightInLbs - controller.currentWeightInteger.value) *
                                10)
                            .round();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.currentWeightUnit.value == 'Lbs'
                    ? TColors.primary
                    : Colors.transparent,
              ),
              child: Text(
                'Lbs',
                style: TextStyle(
                  color: controller.currentWeightUnit.value == 'Lbs'
                      ? TColors.white
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Integer picker
            Container(
              width: THelperFunctions.screenWidth(context) * 0.25,
              height: THelperFunctions.screenHeight(context) * 0.28,
              child: Obx(
                () => CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: controller.currentWeightUnit.value == 'Kg'
                        ? controller.currentWeightInteger.value - 50
                        : controller.currentWeightInteger.value - 110,
                  ), // Starts at 50 kg or 110 lbs
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    controller.currentWeightInteger.value =
                        controller.currentWeightUnit.value == 'Kg'
                            ? index + 50
                            : index + 110;

                    // setState(() {
                    //   if (selectedUnit == 'Kg') {
                    //     selectedInteger = index + 50;
                    //   } else {
                    //     selectedInteger = index + 110;
                    //   }
                    // });
                  },
                  children: List<Widget>.generate(100, (int index) {
                    return Center(
                      child: Text(
                        controller.currentWeightUnit.value == 'Kg'
                            ? (index + 50).toString()
                            : (index + 110).toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Fraction picker
            Container(
              width: THelperFunctions.screenWidth(context) * 0.25,
              height: THelperFunctions.screenHeight(context) * 0.28,
              child: Obx(
                () => CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: controller.currentWeightFraction.value,
                  ),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      controller.currentWeightFraction.value = index;
                    });
                  },
                  children: List<Widget>.generate(10, (int index) {
                    return Center(
                      child: Text(
                        controller.currentWeightUnit.value == 'Kg'
                            ? '.$index kg'
                            : '.$index lbs',
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
