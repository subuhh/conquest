import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'WIdget/MacroNutrientsBreakDownWidget.dart';
import 'WIdget/QuantityMeasurement Widget.dart';

class MealContentPage extends StatelessWidget {
  const MealContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: TColors.primary),
            onPressed: () {},
            child: Text(
              "Add",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(fontWeightDelta: 2, color: Colors.white),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              height: 275,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-w3avbK6DyS2dZy-bsU-TUJagmlG-2_WbgQ&s',
                            height: 150,
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Positioned(
                          left: 30,
                          bottom: 15,
                          child: Text(
                            "Roti",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(fontWeightDelta: 2, color: Colors.white),
                          )),
                    ],
                  ),
                  QuantityMeasureWidget(),

                ],
              ),
            ),

            SizedBox(height: TSizes.spaceBtwSections,),
            //MacroNutrients BreakDown
            MacroNutrientsBreakdownWidget(),
          ],
        ),
      ),
    );
  }
}
