import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../MealContentPage/MealContentPage.dart';

class TrackingMealListCard extends StatelessWidget {
  const TrackingMealListCard({
    super.key,
    required this.mealTiming,
  });
  final String mealTiming;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mealTiming,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(fontWeightDelta: 1),
                ),
                Row(
                  children: [
                    Text(
                      "85 of 725 Cal",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MealContentPage());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 14,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  title: Text(
                    "Roti",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "100 gm roti/chapati",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "85 Cal",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall, // Use subtitle2 or any appropriate style
                      ),
                      SizedBox(width: TSizes.spaceBtwItems / 2),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
