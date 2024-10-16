import 'package:conquest/utils/constants/colors.dart';
import 'package:conquest/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/Controllers/Form_Controller/FormController.dart';

class GoalWeightScreen extends StatefulWidget {
  const GoalWeightScreen({
    Key? key,
  }) : super(key: key);

  @override
  _GoalWeightScreenState createState() => _GoalWeightScreenState();
}

class _GoalWeightScreenState extends State<GoalWeightScreen> {
  final controller = FormController.instance;

  // Conversion methods
  double get weightInKg =>
      controller.goalWeightInteger.value +
      controller.goalWeightFraction.value / 10;
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
                    if (controller.goalWeightUnit.value != 'Kg') {
                      controller.goalWeightUnit.value = 'Kg';
                      // Convert the current lbs value to kg
                      double weightInKg = weightInLbs / 2.20462;
                      controller.goalWeightInteger.value = weightInKg.floor();
                      controller.goalWeightFraction.value =
                          ((weightInKg - controller.goalWeightInteger.value) *
                                  10)
                              .round();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.goalWeightUnit.value == 'Kg'
                      ? TColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  'Kg',
                  style: TextStyle(
                    color: controller.goalWeightUnit.value == 'Kg'
                        ? TColors.white
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (controller.goalWeightUnit.value != 'Lbs') {
                      controller.goalWeightUnit.value = 'Lbs';
                      // Convert the current kg value to lbs
                      double weightInLbs = weightInKg * 2.20462;
                      controller.goalWeightInteger.value = weightInLbs.floor();
                      controller.goalWeightFraction.value =
                          ((weightInLbs - controller.goalWeightInteger.value) *
                                  10)
                              .round();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.goalWeightUnit.value == 'Lbs'
                      ? TColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  'Lbs',
                  style: TextStyle(
                    color: controller.goalWeightUnit.value == 'Lbs'
                        ? TColors.white
                        : Colors.grey,
                  ),
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
                  looping: true,
                  scrollController: FixedExtentScrollController(
                    initialItem: controller.goalWeightUnit.value == 'Kg'
                        ? controller.goalWeightInteger.value - 50
                        : controller.goalWeightInteger.value - 110,
                  ), // Starts at 50 kg or 110 lbs
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    controller.goalWeightInteger.value =
                        controller.goalWeightUnit.value == 'Kg'
                            ? index + 50
                            : index + 110;
                  },
                  children: List<Widget>.generate(100, (int index) {
                    return Center(
                      child: Text(
                        controller.goalWeightUnit.value == 'Kg'
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
                  looping: true,
                  scrollController: FixedExtentScrollController(
                      initialItem: controller.goalWeightFraction.value),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      controller.goalWeightFraction.value = index;
                    });
                  },
                  children: List<Widget>.generate(10, (int index) {
                    return Center(
                      child: Text(
                        controller.goalWeightUnit.value == 'Kg'
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
