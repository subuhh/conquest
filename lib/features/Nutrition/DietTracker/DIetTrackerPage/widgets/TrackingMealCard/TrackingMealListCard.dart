import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../MealContentPage/MealContentPage.dart';

class TrackingMealListCard extends StatelessWidget {
  const TrackingMealListCard({super.key, required this.mealTiming});
  final String mealTiming;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealTiming,
              style: Theme.of(context).textTheme.titleLarge!.apply(fontWeightDelta: 1), // Use headline6 or whatever suits your theme
            ),
            Row(
              children: [
                Text(
                  "85 of 725 Cal",
                  style: Theme.of(context).textTheme.titleMedium, // Use subtitle1 or similar
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: (){
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
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  "Roti",
                  style: Theme.of(context).textTheme.bodyLarge, // Use bodyText1 or another suitable style
                ),
                subtitle: Text(
                  "100 gm roti/chapati",
                  style: Theme.of(context).textTheme.bodyMedium, // Use bodyText2 or similar
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "85 Cal",
                      style: Theme.of(context).textTheme.titleSmall, // Use subtitle2 or any appropriate style
                    ),
                    SizedBox(width: TSizes.spaceBtwItems/2,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),

                          child: Center(child: Icon(Icons.remove_rounded,color: Colors.white,size: 15,))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
